extends CanvasLayer
class_name StartMenu

## Start menu displayed when the game first launches
##
## Provides game title, start option, and access to other screens

signal start_requested

@onready var help_screen = get_node_or_null("../HelpScreen")
@onready var achievements_screen = get_node_or_null("../AchievementsScreen")
@onready var statistics_screen = get_node_or_null("../StatisticsScreen")
@onready var settings_menu = get_node_or_null("../SettingsMenu")

func _ready():
	_connect_buttons()
	show()

func _connect_buttons():
	"""Connect menu button signals"""
	var help_btn = $CenterContainer/VBoxContainer/MenuButtons/HelpButton
	var achievements_btn = $CenterContainer/VBoxContainer/MenuButtons/AchievementsButton
	var stats_btn = $CenterContainer/VBoxContainer/MenuButtons/StatisticsButton
	var settings_btn = $CenterContainer/VBoxContainer/MenuButtons/SettingsButton
	var quit_btn = $CenterContainer/VBoxContainer/MenuButtons/QuitButton

	help_btn.pressed.connect(_on_help_pressed)
	achievements_btn.pressed.connect(_on_achievements_pressed)
	stats_btn.pressed.connect(_on_statistics_pressed)
	settings_btn.pressed.connect(_on_settings_pressed)
	quit_btn.pressed.connect(_on_quit_pressed)

func _input(event):
	if not visible:
		return

	# Start game
	if event.is_action_pressed("ui_accept"):
		start_requested.emit()
		hide()

	# Keyboard shortcuts for menu options
	if event is InputEventKey and event.pressed:
		match event.keycode:
			KEY_H:
				_on_help_pressed()
			KEY_A:
				_on_achievements_pressed()
			KEY_S:
				_on_statistics_pressed()
			KEY_O:
				_on_settings_pressed()
			KEY_ESCAPE:
				_on_quit_pressed()

func show_menu() -> void:
	"""Display the start menu"""
	show()

func _on_help_pressed():
	"""Show help screen"""
	if help_screen:
		help_screen.show_help()
		hide()

func _on_achievements_pressed():
	"""Show achievements screen"""
	if achievements_screen:
		achievements_screen.show_achievements()
		hide()

func _on_statistics_pressed():
	"""Show statistics screen"""
	if statistics_screen:
		statistics_screen.show_statistics()
		hide()

func _on_settings_pressed():
	"""Show settings menu"""
	if settings_menu:
		settings_menu.show_settings()
		hide()

func _on_quit_pressed():
	"""Quit the game"""
	get_tree().quit()

func _on_animation_timer_timeout() -> void:
	"""Animate the start instruction text"""
	var start_label = $CenterContainer/VBoxContainer/StartLabel
	start_label.visible = not start_label.visible
