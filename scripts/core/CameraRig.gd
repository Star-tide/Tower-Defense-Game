extends Node3D
class_name CameraRig

@export var move_speed: float = 12.0
@export var drag_pan_speed: float = 0.02
@export var rotate_sensitivity: float = 0.2
@export var tilt_sensitivity: float = 0.15
@export var min_zoom_distance: float = 6.0
@export var max_zoom_distance: float = 60.0
@export var min_pitch_deg: float = 20.0
@export var max_pitch_deg: float = 75.0
@export var focus_point: Vector3 = Vector3(12, 0, 12)

var camera: Camera3D
var distance: float = 20.0
var yaw_deg: float = 45.0
var pitch_deg: float = 45.0
var dragging_pan: bool = false
var dragging_rotate: bool = false

func _ready() -> void:
	_ensure_actions()
	camera = $Camera3D
	_initialize_from_camera()
	_update_camera_transform()

func _ensure_actions() -> void:
	var actions: Array[String] = [
		"camera_move_forward",
		"camera_move_back",
		"camera_move_left",
		"camera_move_right"
	]
	for action_name in actions:
		if not InputMap.has_action(action_name):
			InputMap.add_action(action_name)
	_add_key_events("camera_move_forward", [Key.KEY_W, Key.KEY_UP])
	_add_key_events("camera_move_back", [Key.KEY_S, Key.KEY_DOWN])
	_add_key_events("camera_move_left", [Key.KEY_A, Key.KEY_LEFT])
	_add_key_events("camera_move_right", [Key.KEY_D, Key.KEY_RIGHT])

func _add_key_events(action_name: String, keys: Array[Key]) -> void:
	for code: Key in keys:
		var ev: InputEventKey = InputEventKey.new()
		ev.physical_keycode = code
		if not InputMap.action_has_event(action_name, ev):
			InputMap.action_add_event(action_name, ev)

func _initialize_from_camera() -> void:
	var initial_offset: Vector3 = camera.transform.origin - focus_point
	distance = initial_offset.length()
	if distance <= 0.001:
		distance = 20.0
	var horizontal_length: float = Vector2(initial_offset.x, initial_offset.z).length()
	yaw_deg = rad_to_deg(atan2(initial_offset.x, initial_offset.z))
	if horizontal_length == 0.0:
		pitch_deg = 45.0
	else:
		pitch_deg = rad_to_deg(atan2(initial_offset.y, horizontal_length))
	pitch_deg = clamp(pitch_deg, min_pitch_deg, max_pitch_deg)

func _process(delta: float) -> void:
	_handle_keyboard_pan(delta)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		var mb: InputEventMouseButton = event
		if mb.button_index == MouseButton.MOUSE_BUTTON_MIDDLE:
			dragging_pan = mb.pressed
		elif mb.button_index == MouseButton.MOUSE_BUTTON_RIGHT:
			dragging_rotate = mb.pressed
		elif mb.button_index == MouseButton.MOUSE_BUTTON_WHEEL_UP and mb.pressed:
			_adjust_zoom(-2.0)
		elif mb.button_index == MouseButton.MOUSE_BUTTON_WHEEL_DOWN and mb.pressed:
			_adjust_zoom(2.0)

	if event is InputEventMouseMotion:
		var motion: InputEventMouseMotion = event
		if dragging_pan:
			_pan_camera(motion.relative)
		elif dragging_rotate:
			_rotate_camera(motion.relative)

func _adjust_zoom(delta_dist: float) -> void:
	distance = clamp(distance + delta_dist, min_zoom_distance, max_zoom_distance)
	_update_camera_transform()

func _pan_camera(relative: Vector2) -> void:
	var yaw_rad: float = deg_to_rad(yaw_deg)
	var right: Vector3 = Vector3(sin(yaw_rad), 0.0, cos(yaw_rad)).normalized()
	var forward: Vector3 = Vector3(-cos(yaw_rad), 0.0, sin(yaw_rad)).normalized()
	var delta_x: float = -relative.x * drag_pan_speed
	var delta_z: float = -relative.y * drag_pan_speed
	var pan_vector: Vector3 = (right * delta_x) + (forward * delta_z)
	focus_point += pan_vector
	global_position += pan_vector
	_update_camera_transform()

func _rotate_camera(relative: Vector2) -> void:
	yaw_deg -= relative.x * rotate_sensitivity
	pitch_deg = clamp(pitch_deg - relative.y * tilt_sensitivity, min_pitch_deg, max_pitch_deg)
	_update_camera_transform()

func _handle_keyboard_pan(delta: float) -> void:
	var input_dir: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("camera_move_forward"):
		input_dir.z -= 1.0
	if Input.is_action_pressed("camera_move_back"):
		input_dir.z += 1.0
	if Input.is_action_pressed("camera_move_left"):
		input_dir.x -= 1.0
	if Input.is_action_pressed("camera_move_right"):
		input_dir.x += 1.0
	if input_dir == Vector3.ZERO:
		return
	var yaw_rad: float = deg_to_rad(yaw_deg)
	var right: Vector3 = Vector3(sin(yaw_rad), 0.0, cos(yaw_rad)).normalized()
	var forward: Vector3 = Vector3(-cos(yaw_rad), 0.0, sin(yaw_rad)).normalized()
	var move: Vector3 = (right * input_dir.x) + (forward * input_dir.z)
	if move.length() > 0.001:
		move = move.normalized() * move_speed * delta
		focus_point += move
		global_position += move
		_update_camera_transform()

func _update_camera_transform() -> void:
	var yaw_rad: float = deg_to_rad(yaw_deg)
	var pitch_rad: float = deg_to_rad(pitch_deg)
	var dir: Vector3 = Vector3(
		sin(yaw_rad) * cos(pitch_rad),
		sin(pitch_rad),
		cos(yaw_rad) * cos(pitch_rad)
	).normalized()
	camera.transform.origin = focus_point + dir * distance
	camera.look_at(focus_point, Vector3.UP)
