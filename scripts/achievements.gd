extends Node

## Achievement tracking system
##
## Tracks player accomplishments across sessions

signal achievement_unlocked(achievement_id: String)

# Achievement definitions
var achievements = {
	"first_game": {
		"name": "First Steps",
		"description": "Play your first game",
		"unlocked": false
	},
	"score_100": {
		"name": "Getting Started",
		"description": "Score 100 points",
		"unlocked": false
	},
	"score_500": {
		"name": "Warming Up",
		"description": "Score 500 points",
		"unlocked": false
	},
	"score_1000": {
		"name": "Skilled Player",
		"description": "Score 1000 points",
		"unlocked": false
	},
	"score_5000": {
		"name": "Expert Dodger",
		"description": "Score 5000 points",
		"unlocked": false
	},
	"survive_60": {
		"name": "One Minute Wonder",
		"description": "Survive for 60 seconds",
		"unlocked": false
	},
	"survive_120": {
		"name": "Two Minute Master",
		"description": "Survive for 2 minutes",
		"unlocked": false
	},
	"survive_300": {
		"name": "Endurance Champion",
		"description": "Survive for 5 minutes",
		"unlocked": false
	},
	"level_5": {
		"name": "Rising Difficulty",
		"description": "Reach difficulty level 5",
		"unlocked": false
	},
	"level_10": {
		"name": "Difficulty Master",
		"description": "Reach difficulty level 10",
		"unlocked": false
	},
	"combo_10": {
		"name": "Combo Starter",
		"description": "Achieve a 10x combo",
		"unlocked": false
	},
	"combo_50": {
		"name": "Combo Master",
		"description": "Achieve a 50x combo",
		"unlocked": false
	},
	"combo_100": {
		"name": "Combo Legend",
		"description": "Achieve a 100x combo",
		"unlocked": false
	},
	"powerup_first": {
		"name": "Powered Up",
		"description": "Collect your first power-up",
		"unlocked": false
	},
	"games_10": {
		"name": "Dedicated Player",
		"description": "Play 10 games",
		"unlocked": false
	},
	"games_50": {
		"name": "Veteran",
		"description": "Play 50 games",
		"unlocked": false
	},
	"games_100": {
		"name": "Centurion",
		"description": "Play 100 games",
		"unlocked": false
	}
}

func _ready():
	load_achievements()

func check_achievement(achievement_id: String) -> bool:
	"""Check and potentially unlock an achievement"""
	if achievement_id in achievements:
		if not achievements[achievement_id]["unlocked"]:
			unlock_achievement(achievement_id)
			return true
	return false

func unlock_achievement(achievement_id: String):
	"""Unlock an achievement"""
	if achievement_id in achievements:
		achievements[achievement_id]["unlocked"] = true
		save_achievements()
		achievement_unlocked.emit(achievement_id)

func get_achievement_progress() -> Dictionary:
	"""Get overall achievement progress"""
	var total = achievements.size()
	var unlocked = 0

	for achievement in achievements.values():
		if achievement["unlocked"]:
			unlocked += 1

	return {
		"total": total,
		"unlocked": unlocked,
		"percentage": (float(unlocked) / float(total)) * 100.0
	}

func save_achievements():
	"""Save achievement data"""
	var file = FileAccess.open("user://achievements.save", FileAccess.WRITE)
	if file:
		file.store_var(achievements)
		file.close()

func load_achievements():
	"""Load achievement data"""
	if FileAccess.file_exists("user://achievements.save"):
		var file = FileAccess.open("user://achievements.save", FileAccess.READ)
		if file:
			var loaded_data = file.get_var()
			if loaded_data:
				# Merge with existing achievements (in case new ones were added)
				for key in loaded_data:
					if key in achievements:
						achievements[key]["unlocked"] = loaded_data[key].get("unlocked", false)
			file.close()

func reset_achievements():
	"""Reset all achievements (for testing)"""
	for achievement in achievements.values():
		achievement["unlocked"] = false
	save_achievements()
