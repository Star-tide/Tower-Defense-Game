extends Node
class_name WaveManager

signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)

@export var enemy_basic_scene: PackedScene

var waves: Array = []
var current_wave_index: int = -1
var level: Level = null
var enemy_manager: EnemyManager = null
var spawning: bool = false

func setup(level_ref: Level, enemy_manager_ref: EnemyManager) -> void:
	level = level_ref
	enemy_manager = enemy_manager_ref
	waves.clear()
	if level.get_wave_config_path().is_empty():
		return
	waves = _load_waves(level.get_wave_config_path())

func start_next_wave() -> void:
	if spawning:
		return
	if waves.is_empty():
		push_warning("No waves configured.")
		return
	current_wave_index += 1
	if current_wave_index >= waves.size():
		push_warning("All waves completed.")
		return
	spawning = true
	_spawn_wave(waves[current_wave_index])

func _spawn_wave(wave_data: Dictionary) -> void:
	var wave_number := current_wave_index + 1
	wave_started.emit(wave_number)
	var delay: float = wave_data.get("delay", 0.0)
	if delay > 0.0:
		await get_tree().create_timer(delay).timeout

	var groups: Array = wave_data.get("groups", [])
	for group in groups:
		var count: int = group.get("count", 1)
		var interval: float = group.get("interval", 1.0)
		for i in range(count):
			_spawn_enemy(group)
			if interval > 0.0:
				await get_tree().create_timer(interval).timeout

	spawning = false
	wave_completed.emit(wave_number)

func _spawn_enemy(group: Dictionary) -> void:
	if enemy_basic_scene == null or level == null or enemy_manager == null:
		push_warning("WaveManager not fully configured; cannot spawn enemy.")
		return
	var enemy = enemy_basic_scene.instantiate()
	if enemy.has_method("setup_path"):
		enemy.setup_path(level.get_path_points(), level.get_spawn_position(), enemy_manager, group.get("speed", 4.0))
	enemy_manager.register_enemy(enemy)
	level.add_child(enemy)

func _load_waves(path: String) -> Array:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_warning("Wave config not found: %s" % path)
		return []
	var data := JSON.parse_string(file.get_as_text())
	if typeof(data) != TYPE_DICTIONARY or not data.has("waves"):
		push_warning("Invalid wave config format: %s" % path)
		return []
	return data["waves"]
