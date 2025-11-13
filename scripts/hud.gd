extends CanvasLayer
class_name HUD

## Heads-Up Display showing game information
##
## Displays:
## - Current score
## - High score
## - Survival time
## - Difficulty level

@onready var score_label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var high_score_label = $MarginContainer/VBoxContainer/HighScoreLabel
@onready var time_label = $MarginContainer/VBoxContainer/TimeLabel
@onready var difficulty_label = $MarginContainer/VBoxContainer/DifficultyLabel

func update_score(score: int) -> void:
	"""Update the displayed score"""
	score_label.text = "Score: %d" % score

func update_high_score(high_score: int) -> void:
	"""Update the displayed high score"""
	high_score_label.text = "High Score: %d" % high_score

func update_time(time: float) -> void:
	"""Update the displayed survival time"""
	var minutes = int(time) / 60
	var seconds = int(time) % 60
	time_label.text = "Time: %02d:%02d" % [minutes, seconds]

func update_difficulty(level: int) -> void:
	"""Update the displayed difficulty level"""
	difficulty_label.text = "Level: %d" % level
