@tool
extends EditorScript

# Builds a MeshLibrary from all GLB files in SRC and saves to OUT.
const SRC := "res://assets/models/kenney_tower_defense_3d/glb"
const OUT := "res://assets/meshlibraries/kenney-mesh-library.meshlib"

func _run() -> void:
	var dir := DirAccess.open(SRC)
	if dir == null:
		printerr("Missing source folder: %s" % SRC)
		return

	# Ensure destination folder exists.
	var dest_dir := OUT.get_base_dir()
	var mk_da := DirAccess.open("res://")
	var mk_err := mk_da.make_dir_recursive(dest_dir)
	if mk_err != OK and mk_err != ERR_ALREADY_EXISTS:
		printerr("Could not create destination folder: %s (code %s)" % [dest_dir, mk_err])
		return

	var lib := MeshLibrary.new()
	var idx := 0

	for f in dir.get_files():
		if not f.to_lower().ends_with(".glb"):
			continue

		var packed := load(SRC.path_join(f))
		if packed == null or not packed is PackedScene:
			printerr("Skipping (not a PackedScene): %s" % f)
			continue

		var inst: Node = (packed as PackedScene).instantiate()
		var mesh: Mesh = _find_mesh(inst)
		if mesh == null:
			printerr("No mesh found in: %s" % f)
			continue

		lib.create_item(idx)
		lib.set_item_name(idx, f.get_basename())
		lib.set_item_mesh(idx, mesh)
		idx += 1

	var save_err := ResourceSaver.save(lib, OUT)
	if save_err != OK:
		printerr("Failed to save MeshLibrary: %s (code %s)" % [OUT, save_err])
	else:
		print("MeshLibrary saved: %s (items: %d)" % [OUT, idx])

func _find_mesh(node: Node) -> Mesh:
	if node is MeshInstance3D and (node as MeshInstance3D).mesh != null:
		return (node as MeshInstance3D).mesh
	for child in node.get_children():
		var m := _find_mesh(child)
		if m != null:
			return m
	return null
