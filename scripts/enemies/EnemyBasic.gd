extends Node3D
class_name EnemyBasic

@export var speed: float = 4.0

var path_points: Array[Vector3] = []
var path_index: int = 0
var enemy_manager: EnemyManager

func setup_path(points: Array[Vector3], spawn_position: Vector3, enemy_manager_ref: EnemyManager, speed_override: float = -1.0) -> void:
	path_points = points.duplicate()
	path_index = 0
	global_transform.origin = spawn_position
	enemy_manager = enemy_manager_ref
	if speed_override > 0.0:
		speed = speed_override

func _process(delta: float) -> void:
	if path_points.is_empty():
		queue_free()
		return
	if path_index >= path_points.size():
		_arrive()
		return
	var target := path_points[path_index]
	var to_target := target - global_transform.origin
	var step := speed * delta
	if to_target.length() <= step:
		global_transform.origin = target
		path_index += 1
	else:
		global_transform.origin += to_target.normalized() * step

func _arrive() -> void:
	if enemy_manager:
		enemy_manager.unregister_enemy(self)
	queue_free()
