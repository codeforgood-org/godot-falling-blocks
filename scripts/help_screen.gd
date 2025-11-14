extends CanvasLayer
class_name HelpScreen

## Help and tutorial screen
##
## Provides game instructions, tips, and information about power-ups

signal help_closed

func _ready():
	hide()

func show_help():
	"""Display the help screen"""
	show()

func _on_close_pressed():
	"""Close help screen"""
	help_closed.emit()
	hide()

func _input(event):
	"""Handle input for closing"""
	if visible and (event.is_action_pressed("ui_cancel") or event.is_action_pressed("ui_accept")):
		_on_close_pressed()
