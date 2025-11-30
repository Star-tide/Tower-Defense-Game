extends CanvasLayer
class_name HUD

@onready var build_menu: Control = $BuildMenu

func show_message(text: String) -> void:
	# Placeholder hook to show notifications.
	print(text)
