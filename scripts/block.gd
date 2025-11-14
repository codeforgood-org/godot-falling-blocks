extends ColorRect
class_name Block

## Falling block that the player must avoid
##
## Blocks fall from the top of the screen at a configurable speed.
## They increase in speed as the game progresses (difficulty scaling).

var speed: float = 200.0
var base_speed: float = 200.0

@onready var viewport_size = get_viewport_rect().size

func _ready():
	# Initialize block appearance
	color = Color.CRIMSON
	size = Vector2(40, 40)

func _process(delta):
	# Move block downward
	position.y += speed * delta

	# Remove block if it goes off screen
	if position.y > viewport_size.y + 50:
		queue_free()

func set_difficulty_multiplier(multiplier: float) -> void:
	"""Adjust block speed based on difficulty"""
	speed = base_speed * multiplier

func get_collision_rect() -> Rect2:
	"""Returns the collision rectangle for this block"""
	return Rect2(position, size)
