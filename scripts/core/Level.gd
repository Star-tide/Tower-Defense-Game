extends Node3D
class_name Level

@export var path_config: String = "res://resources/grids/level1_path.json"
@export var wave_config: String = "res://resources/waves/level1_waves.json"

var spawn_position: Vector3 = Vector3.ZERO
var goal_position: Vector3 = Vector3.ZERO
var path_points: Array[Vector3] = []

func _ready() -> void:
	_load_path()

func _load_path() -> void:
	var file := FileAccess.open(path_config, FileAccess.READ)
	if file == null:
		push_warning("Path config not found: %s" % path_config)
		return
	var data := JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY:
		push_warning("Invalid path config format: %s" % path_config)
		return
	var spawn := data.get("spawn", [0, 0, 0])
	var goal := data.get("goal", [0, 0, 10])
	var points := data.get("path", [])
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
