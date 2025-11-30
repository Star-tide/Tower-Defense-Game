@tool
extends EditorScript

# Batch-generate tile scenes from GLB files without hand-editing .tscn files.
# Adjust these paths if needed.
const SOURCE_DIR := "res://assets/models/kenney_tower_defense_3d/glb"
const DEST_DIR := "res://scenes/environment/tiles"
const ADD_COLLISION := true
const OVERWRITE_EXISTING := false

func _run() -> void:
	var da := DirAccess.open(SOURCE_DIR)
	if da == null:
		printerr("Could not open source dir: %s" % SOURCE_DIR)
		return

	DirAccess.make_dir_recursive_absolute(DEST_DIR)

	for file_name in da.get_files():
		if not file_name.to_lower().ends_with(".glb"):
			continue
		var src_path := SOURCE_DIR.path_join(file_name)
		var base := file_name.get_basename()  # without .glb
		var dest_path := DEST_DIR.path_join("%s.tscn" % base)

		if not OVERWRITE_EXISTING and FileAccess.file_exists(dest_path):
			print("Skip existing: %s" % dest_path)
			continue

		var packed := load(src_path)
		if packed == null or not packed is PackedScene:
			printerr("Failed to load PackedScene: %s" % src_path)
			continue
		var inst: Node = (packed as PackedScene).instantiate()
		var mesh: Mesh = _find_mesh(inst)
		if mesh == null:
			printerr("No Mesh found in: %s" % src_path)
			continue

		var root := Node3D.new()
		root.name = base

		var mesh_instance := MeshInstance3D.new()
		mesh_instance.name = "Mesh"
		mesh_instance.mesh = mesh
		root.add_child(mesh_instance)
		mesh_instance.owner = root

		if ADD_COLLISION:
			var static_body: StaticBody3D = StaticBody3D.new()
			static_body.name = "StaticBody3D"
			root.add_child(static_body)
			static_body.owner = root

			var collision: CollisionShape3D = CollisionShape3D.new()
			collision.name = "CollisionShape3D"
			var shape: Shape3D = mesh.create_trimesh_shape()
			collision.shape = shape
			static_body.add_child(collision)
			collision.owner = root

		var scene := PackedScene.new()
		var ok := scene.pack(root)
		if ok != OK:
			printerr("Failed to pack scene for: %s" % src_path)
			continue
		var save_result := ResourceSaver.save(scene, dest_path)
		if save_result != OK:
			printerr("Failed to save scene: %s (code %s)" % [dest_path, save_result])
		else:
			print("Created: %s" % dest_path)

func _find_mesh(node: Node) -> Mesh:
	if node is MeshInstance3D and (node as MeshInstance3D).mesh != null:
		return (node as MeshInstance3D).mesh
	for child in node.get_children():
		var found := _find_mesh(child)
		if found != null:
			return found
	return null
