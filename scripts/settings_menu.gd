extends CanvasLayer
class_name SettingsMenu

## Settings and options menu
##
## Allows players to adjust:
## - Music and SFX volume
## - Fullscreen toggle
## - Difficulty presets
## - Controls display

signal settings_closed

@onready var music_slider = $Panel/MarginContainer/VBoxContainer/MusicVolume/HSlider
@onready var sfx_slider = $Panel/MarginContainer/VBoxContainer/SFXVolume/HSlider
@onready var fullscreen_toggle = $Panel/MarginContainer/VBoxContainer/FullscreenToggle
@onready var difficulty_option = $Panel/MarginContainer/VBoxContainer/DifficultyPreset/OptionButton

var settings_data = {
	"music_volume": 0.7,
	"sfx_volume": 0.8,
	"fullscreen": false,
	"difficulty_preset": "Normal"
}

func _ready():
	hide()
	load_settings()
	_connect_signals()
	_apply_settings()

func _connect_signals():
	"""Connect UI element signals"""
	music_slider.value_changed.connect(_on_music_volume_changed)
	sfx_slider.value_changed.connect(_on_sfx_volume_changed)
	fullscreen_toggle.toggled.connect(_on_fullscreen_toggled)
	difficulty_option.item_selected.connect(_on_difficulty_changed)

	$Panel/MarginContainer/VBoxContainer/CloseButton.pressed.connect(_on_close_pressed)

func show_settings():
	"""Display the settings menu"""
	show()

func load_settings():
	"""Load settings from GameManager"""
	if GameManager:
		settings_data = GameManager.settings.duplicate()

	# Update UI to match settings
	music_slider.value = settings_data.get("music_volume", 0.7) * 100
	sfx_slider.value = settings_data.get("sfx_volume", 0.8) * 100
	fullscreen_toggle.button_pressed = settings_data.get("fullscreen", false)

	var diff = settings_data.get("difficulty_preset", "Normal")
	match diff:
		"Easy": difficulty_option.selected = 0
		"Normal": difficulty_option.selected = 1
		"Hard": difficulty_option.selected = 2
		"Extreme": difficulty_option.selected = 3

func save_settings():
	"""Save settings to GameManager"""
	if GameManager:
		GameManager.settings = settings_data.duplicate()
		GameManager.save_game_data()

func _apply_settings():
	"""Apply current settings to the game"""
	if AudioManager:
		AudioManager.music_volume = settings_data.get("music_volume", 0.7)
		AudioManager.sfx_volume = settings_data.get("sfx_volume", 0.8)

	var fullscreen = settings_data.get("fullscreen", false)
	if fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_music_volume_changed(value: float):
	"""Handle music volume slider change"""
	settings_data["music_volume"] = value / 100.0
	_apply_settings()
	save_settings()

func _on_sfx_volume_changed(value: float):
	"""Handle SFX volume slider change"""
	settings_data["sfx_volume"] = value / 100.0
	_apply_settings()
	save_settings()
	if AudioManager:
		AudioManager.play_sfx("menu_select")

func _on_fullscreen_toggled(toggled: bool):
	"""Handle fullscreen toggle"""
	settings_data["fullscreen"] = toggled
	_apply_settings()
	save_settings()

func _on_difficulty_changed(index: int):
	"""Handle difficulty preset change"""
	var difficulties = ["Easy", "Normal", "Hard", "Extreme"]
	settings_data["difficulty_preset"] = difficulties[index]
	save_settings()

func _on_close_pressed():
	"""Close settings menu"""
	settings_closed.emit()
	hide()

func _input(event):
	"""Handle input for closing menu"""
	if visible and event.is_action_pressed("ui_cancel"):
		_on_close_pressed()
