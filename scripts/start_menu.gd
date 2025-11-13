extends CanvasLayer
class_name StartMenu

## Start menu displayed when the game first launches
##
## Provides game title and instructions to begin

signal start_requested

func _ready():
	show()

func _input(event):
	if visible and event.is_action_pressed("ui_accept"):
		start_requested.emit()
		hide()

func show_menu() -> void:
	"""Display the start menu"""
	show()

func _on_animation_timer_timeout() -> void:
	"""Animate the start instruction text"""
	var start_label = $CenterContainer/VBoxContainer/StartLabel
	start_label.visible = not start_label.visible
