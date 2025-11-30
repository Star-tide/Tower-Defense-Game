extends Node3D
class_name Level

@export var path_config: String = "res://resources/grids/level1_path.json"
@export var wave_config: String = "res://resources/waves/level1_waves.json"
@export var ground_size: Vector2 = Vector2(24, 24)
@export var ground_height: float = 0.25
@export var path_tile_size: Vector3 = Vector3(1, 0.2, 1)
@export var path_tile_spacing: float = 1.0
@export var ground_color: Color = Color(0.15, 0.15, 0.18)
@export var path_color: Color = Color(0.55, 0.8, 0.95)

var spawn_position: Vector3 = Vector3.ZERO
var goal_position: Vector3 = Vector3.ZERO
var path_points: Array[Vector3] = []
var path_mesh: BoxMesh
var ground_mesh: BoxMesh

func _ready() -> void:
	_load_path()
	_build_ground()
	_build_path_tiles()

func _load_path() -> void:
	var file := FileAccess.open(path_config, FileAccess.READ)
	if file == null:
		push_warning("Path config not found: %s" % path_config)
		return
	var data: Variant = JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		push_warning("Invalid path config format: %s" % path_config)
		return
	var spawn: Array = (data.get("spawn", [0, 0, 0]) as Array)
	var goal: Array = (data.get("goal", [0, 0, 10]) as Array)
	var points: Array = (data.get("path", []) as Array)
	spawn_position = Vector3(spawn[0], spawn[1], spawn[2])
	goal_position = Vector3(goal[0], goal[1], goal[2])
	path_points = []
	for p in points:
		if p.size() >= 3:
			path_points.append(Vector3(p[0], p[1], p[2]))
	if path_points.is_empty():
		path_points.append_array([spawn_position, goal_position])

func get_wave_config_path() -> String:
	return wave_config

func get_path_points() -> Array[Vector3]:
	return path_points

func get_spawn_position() -> Vector3:
	return spawn_position

func _build_ground() -> void:
	ground_mesh = BoxMesh.new()
	ground_mesh.size = Vector3(ground_size.x, ground_height, ground_size.y)
	var ground_mat := StandardMaterial3D.new()
	ground_mat.albedo_color = ground_color
	ground_mat.roughness = 1.0
	ground_mesh.material = ground_mat

	var ground := MeshInstance3D.new()
	ground.mesh = ground_mesh
	ground.position = Vector3(ground_size.x * 0.5, -ground_height * 0.5, ground_size.y * 0.5)
	add_child(ground)

func _build_path_tiles() -> void:
	if path_points.size() < 2:
		return
	path_mesh = BoxMesh.new()
	path_mesh.size = path_tile_size
	var path_mat := StandardMaterial3D.new()
	path_mat.albedo_color = path_color
	path_mat.roughness = 0.6
	path_mesh.material = path_mat

	for i in range(path_points.size() - 1):
		var start := path_points[i]
		var finish := path_points[i + 1]
		var segment := finish - start
		var distance := segment.length()
		if distance <= 0.001:
			_place_path_tile(start)
			continue
		var dir := segment.normalized()
		var steps := int(ceil(distance / max(path_tile_spacing, 0.1)))
		for s in range(steps + 1):
			var t := min(s * path_tile_spacing, distance)
			var pos: Vector3 = start + dir * t
			_place_path_tile(pos)

func _place_path_tile(pos: Vector3) -> void:
	var tile := MeshInstance3D.new()
	tile.mesh = path_mesh
	tile.position = pos + Vector3(0, path_tile_size.y * 0.5, 0)
	add_child(tile)
