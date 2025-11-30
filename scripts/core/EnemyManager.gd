extends Node
class_name EnemyManager

var active_enemies: Array = []

func register_enemy(enemy: Node) -> void:
	active_enemies.append(enemy)

func unregister_enemy(enemy: Node) -> void:
	active_enemies.erase(enemy)

func get_targets() -> Array:
	return active_enemies
