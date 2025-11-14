extends Node

## Global statistics tracker
##
## Tracks lifetime player statistics across all game sessions

var stats = {
	"total_games_played": 0,
	"total_time_played": 0.0,  # In seconds
	"total_blocks_dodged": 0,
	"total_score": 0,
	"best_score": 0,
	"best_survival_time": 0.0,
	"best_combo": 0,
	"best_level_reached": 0,
	"total_powerups_collected": 0,
	"total_deaths": 0
}

func _ready():
	load_statistics()

func record_game_end(score: int, time: float, level: int, blocks_dodged: int, best_combo: int):
	"""Record statistics from a completed game"""
	stats["total_games_played"] += 1
	stats["total_time_played"] += time
	stats["total_blocks_dodged"] += blocks_dodged
	stats["total_score"] += score
	stats["total_deaths"] += 1

	# Update bests
	if score > stats["best_score"]:
		stats["best_score"] = score

	if time > stats["best_survival_time"]:
		stats["best_survival_time"] = time

	if best_combo > stats["best_combo"]:
		stats["best_combo"] = best_combo

	if level > stats["best_level_reached"]:
		stats["best_level_reached"] = level

	save_statistics()

	# Check achievements
	_check_stat_achievements()

func record_powerup_collected():
	"""Record a power-up collection"""
	stats["total_powerups_collected"] += 1
	save_statistics()

	if stats["total_powerups_collected"] == 1:
		Achievements.check_achievement("powerup_first")

func get_average_score() -> float:
	"""Calculate average score per game"""
	if stats["total_games_played"] > 0:
		return float(stats["total_score"]) / float(stats["total_games_played"])
	return 0.0

func get_average_survival_time() -> float:
	"""Calculate average survival time per game"""
	if stats["total_games_played"] > 0:
		return stats["total_time_played"] / float(stats["total_games_played"])
	return 0.0

func get_formatted_total_time() -> String:
	"""Get formatted total time played"""
	var hours = int(stats["total_time_played"]) / 3600
	var minutes = (int(stats["total_time_played"]) % 3600) / 60
	var seconds = int(stats["total_time_played"]) % 60

	if hours > 0:
		return "%dh %dm %ds" % [hours, minutes, seconds]
	elif minutes > 0:
		return "%dm %ds" % [minutes, seconds]
	else:
		return "%ds" % seconds

func _check_stat_achievements():
	"""Check and unlock achievements based on statistics"""
	# Games played
	if stats["total_games_played"] >= 1:
		Achievements.check_achievement("first_game")
	if stats["total_games_played"] >= 10:
		Achievements.check_achievement("games_10")
	if stats["total_games_played"] >= 50:
		Achievements.check_achievement("games_50")
	if stats["total_games_played"] >= 100:
		Achievements.check_achievement("games_100")

func save_statistics():
	"""Save statistics to file"""
	var file = FileAccess.open("user://statistics.save", FileAccess.WRITE)
	if file:
		file.store_var(stats)
		file.close()

func load_statistics():
	"""Load statistics from file"""
	if FileAccess.file_exists("user://statistics.save"):
		var file = FileAccess.open("user://statistics.save", FileAccess.READ)
		if file:
			var loaded_data = file.get_var()
			if loaded_data:
				stats = loaded_data
			file.close()

func reset_statistics():
	"""Reset all statistics (for testing)"""
	for key in stats:
		if typeof(stats[key]) == TYPE_FLOAT:
			stats[key] = 0.0
		else:
			stats[key] = 0
	save_statistics()
