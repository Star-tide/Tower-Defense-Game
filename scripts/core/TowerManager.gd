extends Node

var placed_towers: Array = []

func add_tower(tower: Node) -> void:
	placed_towers.append(tower)

func remove_tower(tower: Node) -> void:
	placed_towers.erase(tower)

func get_towers() -> Array:
	return placed_towers
