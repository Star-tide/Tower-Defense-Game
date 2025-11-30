extends Node

signal wave_started(wave_number: int)
signal wave_completed(wave_number: int)

var current_wave: int = 0

func start_next_wave() -> void:
	current_wave += 1
	wave_started.emit(current_wave)
	# TODO: load wave data and trigger spawns.

func complete_wave() -> void:
	wave_completed.emit(current_wave)
