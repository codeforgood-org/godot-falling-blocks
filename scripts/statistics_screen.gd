extends CanvasLayer
class_name StatisticsScreen

## Statistics viewer
##
## Displays lifetime player statistics

signal statistics_closed

@onready var stats_container = $Panel/MarginContainer/VBoxContainer/StatsContainer

func _ready():
	hide()

func show_statistics():
	"""Display the statistics screen"""
	_populate_statistics()
	show()

func _populate_statistics():
	"""Populate statistics display"""
	# Clear existing items
	for child in stats_container.get_children():
		child.queue_free()

	# Add each statistic
	_add_stat_item("Games Played", str(Statistics.stats["total_games_played"]))
	_add_stat_item("Total Time Played", Statistics.get_formatted_total_time())
	_add_stat_item("Total Blocks Dodged", str(Statistics.stats["total_blocks_dodged"]))
	_add_stat_item("Total Score", str(Statistics.stats["total_score"]))
	_add_stat_item("Best Score", str(Statistics.stats["best_score"]))

	var best_time = Statistics.stats["best_survival_time"]
	var minutes = int(best_time) / 60
	var seconds = int(best_time) % 60
	_add_stat_item("Best Survival Time", "%02d:%02d" % [minutes, seconds])

	_add_stat_item("Best Combo", str(Statistics.stats["best_combo"]))
	_add_stat_item("Best Level Reached", str(Statistics.stats["best_level_reached"]))
	_add_stat_item("Power-Ups Collected", str(Statistics.stats["total_powerups_collected"]))
	_add_stat_item("Average Score", "%.1f" % Statistics.get_average_score())
	_add_stat_item("Average Survival", "%.1f seconds" % Statistics.get_average_survival_time())

func _add_stat_item(label: String, value: String):
	"""Add a statistic item to the display"""
	var container = HBoxContainer.new()

	var label_node = Label.new()
	label_node.text = label + ":"
	label_node.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	container.add_child(label_node)

	var value_node = Label.new()
	value_node.text = value
	value_node.add_theme_color_override("font_color", Color.GOLD)
	value_node.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	container.add_child(value_node)

	stats_container.add_child(container)

func _on_close_pressed():
	"""Close statistics screen"""
	statistics_closed.emit()
	hide()

func _input(event):
	"""Handle input for closing"""
	if visible and event.is_action_pressed("ui_cancel"):
		_on_close_pressed()
