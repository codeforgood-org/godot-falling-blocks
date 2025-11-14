extends ColorRect
class_name PowerUp

## Power-up collectible that grants temporary abilities
##
## Types:
## - SHIELD: Grants invincibility for a short time
## - SLOW_MOTION: Slows down falling blocks
## - SCORE_MULTIPLIER: Doubles points earned
## - SHRINK: Reduces player size temporarily

enum PowerUpType {
	SHIELD,
	SLOW_MOTION,
	SCORE_MULTIPLIER,
	SHRINK
}

var type: PowerUpType
var fall_speed: float = 150.0

@onready var viewport_size = get_viewport_rect().size

# Power-up colors
const COLORS = {
	PowerUpType.SHIELD: Color.CYAN,
	PowerUpType.SLOW_MOTION: Color.YELLOW,
	PowerUpType.SCORE_MULTIPLIER: Color.GOLD,
	PowerUpType.SHRINK: Color.MAGENTA
}

# Power-up durations (in seconds)
const DURATIONS = {
	PowerUpType.SHIELD: 5.0,
	PowerUpType.SLOW_MOTION: 7.0,
	PowerUpType.SCORE_MULTIPLIER: 10.0,
	PowerUpType.SHRINK: 8.0
}

func _ready():
	size = Vector2(30, 30)
	_set_random_type()

func _process(delta):
	position.y += fall_speed * delta

	# Remove if off screen
	if position.y > viewport_size.y + 50:
		queue_free()

	# Pulsating animation
	var pulse = sin(Time.get_ticks_msec() / 200.0) * 0.2 + 0.8
	scale = Vector2.ONE * pulse

func _set_random_type():
	"""Randomly select a power-up type"""
	type = PowerUpType.values()[randi() % PowerUpType.size()]
	color = COLORS[type]

func get_collision_rect() -> Rect2:
	"""Returns the collision rectangle"""
	return Rect2(global_position, size * scale)

func get_duration() -> float:
	"""Get the duration of this power-up's effect"""
	return DURATIONS[type]

func get_type_name() -> String:
	"""Get a human-readable name for this power-up"""
	match type:
		PowerUpType.SHIELD:
			return "Shield"
		PowerUpType.SLOW_MOTION:
			return "Slow Motion"
		PowerUpType.SCORE_MULTIPLIER:
			return "2x Score"
		PowerUpType.SHRINK:
			return "Shrink"
		_:
			return "Unknown"
