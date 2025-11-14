extends Node

## Global game manager for persistent data and settings
##
## This autoload singleton manages game-wide state like settings,
## high scores, and other persistent data.

const SAVE_PATH = "user://game_data.save"

var high_score: int = 0
var settings: Dictionary = {
	"music_volume": 0.8,
	"sfx_volume": 1.0,
	"fullscreen": false
}

func _ready():
	load_game_data()

func save_game_data() -> void:
	"""Save all persistent game data"""
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		var data = {
			"high_score": high_score,
			"settings": settings
		}
		file.store_var(data)
		file.close()

func load_game_data() -> void:
	"""Load persistent game data"""
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var data = file.get_var()
			if data:
				high_score = data.get("high_score", 0)
				settings = data.get("settings", settings)
			file.close()
