extends Node3D
class_name GameRoot

@onready var wave_manager: WaveManager = $WaveManager
@onready var enemy_manager: EnemyManager = $EnemyManager
@onready var tower_manager: TowerManager = $TowerManager
@onready var hud: CanvasLayer = $HUD

func _ready() -> void:
	# Entry point for wiring managers and UI; expand as systems come online.
	pass

func start_game() -> void:
	# Placeholder for bootstrapping a level, spawns, and UI state.
	pass
