extends Node3D
class_name CameraRig

@export var drag_pan_speed: float = 0.05
@export var zoom_step: float = 2.0
@export var min_zoom_distance: float = 6.0
@export var max_zoom_distance: float = 40.0
@export var focus_point: Vector3 = Vector3(12, 0, 12)

var camera: Camera3D
var camera_direction: Vector3 = Vector3.ZERO
var target_distance: float = 12.0
var dragging: bool = false
var last_mouse_position: Vector2 = Vector2.ZERO

func _ready() -> void:
	camera = $Camera3D
	var initial_offset: Vector3 = camera.transform.origin - focus_point
	camera_direction = initial_offset.normalized()
	target_distance = initial_offset.length()
	camera.look_at(focus_point, Vector3.UP)
	_apply_zoom()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event
		if mb.button_index == MouseButton.MOUSE_BUTTON_MIDDLE:
			dragging = mb.pressed
			last_mouse_position = mb.position
		elif mb.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP and mb.pressed:
			_adjust_zoom(-zoom_step)
		elif mb.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN and mb.pressed:
			_adjust_zoom(zoom_step)

	if event is InputEventMouseMotion and dragging:
		var motion: InputEventMouseMotion = event
		_pan_camera(motion.relative)

func _adjust_zoom(delta_dist: float) -> void:
	target_distance = clamp(target_distance + delta_dist, min_zoom_distance, max_zoom_distance)
	_apply_zoom()

func _apply_zoom() -> void:
	var new_position: Vector3 = focus_point + camera_direction * target_distance
	camera.transform.origin = new_position
	camera.look_at(focus_point, Vector3.UP)

func _pan_camera(relative: Vector2) -> void:
	var camera_basis: Basis = camera.global_transform.basis
	var right: Vector3 = Vector3(camera_basis.x.x, 0.0, camera_basis.x.z).normalized()
	var forward: Vector3 = Vector3(camera_basis.z.x, 0.0, camera_basis.z.z).normalized()
	var delta_x: float = -relative.x * drag_pan_speed
	var delta_z: float = -relative.y * drag_pan_speed
	var pan_vector: Vector3 = (right * delta_x) + (forward * delta_z)
	global_position += pan_vector
	focus_point += pan_vector
	_apply_zoom()
