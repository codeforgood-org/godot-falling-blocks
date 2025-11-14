extends CanvasLayer
class_name AchievementsScreen

## Achievements display screen
##
## Shows all available achievements and their unlock status

signal achievements_closed

@onready var achievements_list = $ScrollContainer/PanelContainer/MarginContainer/VBoxContainer/AchievementsList
@onready var progress_label = $ScrollContainer/PanelContainer/MarginContainer/VBoxContainer/ProgressLabel

func _ready():
	hide()

func show_achievements():
	"""Display the achievements screen"""
	_populate_achievements()
	show()

func _populate_achievements():
	"""Populate the achievements list"""
	# Clear existing items
	for child in achievements_list.get_children():
		child.queue_free()

	# Get achievement progress
	var progress = Achievements.get_achievement_progress()
	progress_label.text = "Unlocked: %d / %d (%.1f%%)" % [
		progress["unlocked"],
		progress["total"],
		progress["percentage"]
	]

	# Add each achievement
	for achievement_id in Achievements.achievements:
		var achievement = Achievements.achievements[achievement_id]
		var item = _create_achievement_item(achievement_id, achievement)
		achievements_list.add_child(item)

func _create_achievement_item(achievement_id: String, achievement: Dictionary) -> Control:
	"""Create a UI element for an achievement"""
	var container = HBoxContainer.new()
	container.add_theme_constant_override("separation", 15)

	# Status indicator
	var status = Label.new()
	status.text = "✓" if achievement["unlocked"] else "○"
	status.add_theme_font_size_override("font_size", 24)
	if achievement["unlocked"]:
		status.add_theme_color_override("font_color", Color.GOLD)
	else:
		status.add_theme_color_override("font_color", Color.DARK_GRAY)
	container.add_child(status)

	# Achievement info
	var info = VBoxContainer.new()
	info.size_flags_horizontal = Control.SIZE_EXPAND_FILL

	var name_label = Label.new()
	name_label.text = achievement["name"]
	name_label.add_theme_font_size_override("font_size", 18)
	if achievement["unlocked"]:
		name_label.add_theme_color_override("font_color", Color.WHITE)
	else:
		name_label.add_theme_color_override("font_color", Color.GRAY)
	info.add_child(name_label)

	var desc_label = Label.new()
	desc_label.text = achievement["description"]
	desc_label.add_theme_font_size_override("font_size", 14)
	desc_label.add_theme_color_override("font_color", Color.LIGHT_GRAY)
	info.add_child(desc_label)

	container.add_child(info)

	return container

func _on_close_pressed():
	"""Close achievements screen"""
	achievements_closed.emit()
	hide()

func _input(event):
	"""Handle input for closing"""
	if visible and event.is_action_pressed("ui_cancel"):
		_on_close_pressed()
