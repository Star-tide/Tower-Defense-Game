extends Node3D
class_name GameRoot

@onready var level: Level = $Level
@onready var wave_manager: WaveManager = $WaveManager
@onready var enemy_manager: EnemyManager = $EnemyManager
@onready var tower_manager: TowerManager = $TowerManager
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	start_game()

func start_game() -> void:
	wave_manager.setup(level, enemy_manager)
	wave_manager.start_next_wave()
