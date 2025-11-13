extends CanvasLayer
class_name HUD

## Heads-Up Display showing game information
##
## Displays:
## - Current score
## - High score
## - Survival time
## - Difficulty level
## - Combo counter and multiplier
## - Active power-ups

@onready var score_label = $MarginContainer/VBoxContainer/ScoreLabel
@onready var high_score_label = $MarginContainer/VBoxContainer/HighScoreLabel
@onready var time_label = $MarginContainer/VBoxContainer/TimeLabel
@onready var difficulty_label = $MarginContainer/VBoxContainer/DifficultyLabel
@onready var combo_label = $MarginContainer/VBoxContainer/ComboLabel
@onready var powerup_container = $MarginContainer/VBoxContainer/PowerUpContainer

var active_powerup_labels: Array = []

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

func update_combo(combo: int, multiplier: float) -> void:
	"""Update the displayed combo counter"""
	if combo > 0:
		combo_label.text = "Combo: %dx (%.1fx multiplier)" % [combo, multiplier]
		combo_label.add_theme_color_override("font_color", _get_combo_color(combo))
		combo_label.show()
	else:
		combo_label.hide()

func _get_combo_color(combo: int) -> Color:
	"""Get color based on combo level"""
	if combo >= 100:
		return Color.GOLD
	elif combo >= 50:
		return Color.ORANGE
	elif combo >= 20:
		return Color.YELLOW
	elif combo >= 10:
		return Color.GREEN_YELLOW
	else:
		return Color.WHITE

func add_active_powerup(name: String, duration: float) -> void:
	"""Add a power-up to the active display"""
	var label = Label.new()
	label.text = "%s (%.1fs)" % [name, duration]
	label.add_theme_font_size_override("font_size", 14)
	powerup_container.add_child(label)
	active_powerup_labels.append({"label": label, "duration": duration, "name": name})

func clear_active_powerups() -> void:
	"""Clear all active power-up displays"""
	for child in powerup_container.get_children():
		child.queue_free()
	active_powerup_labels.clear()

func _process(delta: float) -> void:
	"""Update power-up timers"""
	for i in range(active_powerup_labels.size() - 1, -1, -1):
		var powerup = active_powerup_labels[i]
		powerup["duration"] -= delta

		if powerup["duration"] <= 0:
			powerup["label"].queue_free()
			active_powerup_labels.remove_at(i)
		else:
			powerup["label"].text = "%s (%.1fs)" % [powerup["name"], powerup["duration"]]
