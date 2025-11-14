extends ColorRect
class_name Player

## Player character that moves left and right to avoid falling blocks
##
## Controls:
## - Left Arrow / A: Move left
## - Right Arrow / D: Move right

const PLAYER_SPEED = 300

@onready var viewport_size = get_viewport_rect().size

func _ready():
	# Initialize player appearance
	color = Color.DODGER_BLUE
	size = Vector2(50, 50)
	position = Vector2(viewport_size.x / 2 - 25, viewport_size.y - 70)

func _process(delta):
	handle_input(delta)

func handle_input(delta: float) -> void:
	"""Handle player movement input"""
	var direction = Input.get_axis("ui_left", "ui_right")
	position.x += direction * PLAYER_SPEED * delta

	# Clamp player position to viewport bounds
	position.x = clamp(position.x, 0, viewport_size.x - size.x)

func get_collision_rect() -> Rect2:
	"""Returns the collision rectangle for this player"""
	return Rect2(position, size)
