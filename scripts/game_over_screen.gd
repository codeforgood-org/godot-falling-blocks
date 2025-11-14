extends CanvasLayer
class_name GameOverScreen

## Game Over screen displayed when the player loses
##
## Shows final statistics and restart instructions

signal restart_requested

@onready var final_score_label = $CenterContainer/PanelContainer/VBoxContainer/FinalScoreLabel
@onready var final_time_label = $CenterContainer/PanelContainer/VBoxContainer/FinalTimeLabel
@onready var high_score_label = $CenterContainer/PanelContainer/VBoxContainer/HighScoreLabel

func _ready():
	hide()

func show_game_over(score: int, time: float, high_score: int) -> void:
	"""Display the game over screen with final statistics"""
	final_score_label.text = "Final Score: %d" % score

	var minutes = int(time) / 60
	var seconds = int(time) % 60
	final_time_label.text = "Survival Time: %02d:%02d" % [minutes, seconds]

	if score >= high_score:
		high_score_label.text = "NEW HIGH SCORE!"
		high_score_label.add_theme_color_override("font_color", Color.GOLD)
	else:
		high_score_label.text = "High Score: %d" % high_score
		high_score_label.add_theme_color_override("font_color", Color.WHITE)

	show()

func _input(event):
	if visible and event.is_action_pressed("restart"):
		restart_requested.emit()
		hide()
