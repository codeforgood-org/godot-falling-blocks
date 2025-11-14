extends Node
class_name ComboSystem

## Combo system for tracking consecutive successful dodges
##
## Awards bonus points and increases score multiplier as combo builds

signal combo_changed(combo_count: int)
signal combo_broken
signal multiplier_increased(multiplier: float)

var current_combo: int = 0
var combo_multiplier: float = 1.0
var time_since_last_dodge: float = 0.0

# Combo settings
const COMBO_TIMEOUT = 2.0  # Seconds without dodging before combo breaks
const POINTS_PER_COMBO = 5
const COMBO_THRESHOLDS = [5, 10, 20, 50, 100]  # Combo milestones
const MULTIPLIER_BONUSES = [1.5, 2.0, 3.0, 5.0, 10.0]  # Multipliers at each threshold

func _process(delta: float):
	if current_combo > 0:
		time_since_last_dodge += delta
		if time_since_last_dodge > COMBO_TIMEOUT:
			break_combo()

func register_dodge():
	"""Register a successful dodge"""
	current_combo += 1
	time_since_last_dodge = 0.0

	# Update multiplier based on combo
	_update_multiplier()

	combo_changed.emit(current_combo)

func break_combo():
	"""Break the current combo"""
	if current_combo > 0:
		combo_broken.emit()

	current_combo = 0
	combo_multiplier = 1.0
	time_since_last_dodge = 0.0

	combo_changed.emit(current_combo)
	multiplier_increased.emit(combo_multiplier)

func _update_multiplier():
	"""Update score multiplier based on combo count"""
	var old_multiplier = combo_multiplier
	combo_multiplier = 1.0

	# Check each threshold
	for i in range(COMBO_THRESHOLDS.size()):
		if current_combo >= COMBO_THRESHOLDS[i]:
			combo_multiplier = MULTIPLIER_BONUSES[i]

	# Emit signal if multiplier changed
	if combo_multiplier != old_multiplier:
		multiplier_increased.emit(combo_multiplier)

func get_combo_bonus() -> int:
	"""Calculate bonus points from current combo"""
	return current_combo * POINTS_PER_COMBO

func get_combo_rank() -> String:
	"""Get a rank name for the current combo"""
	if current_combo >= 100:
		return "LEGENDARY!"
	elif current_combo >= 50:
		return "GODLIKE!"
	elif current_combo >= 20:
		return "AMAZING!"
	elif current_combo >= 10:
		return "EXCELLENT!"
	elif current_combo >= 5:
		return "GREAT!"
	else:
		return ""
