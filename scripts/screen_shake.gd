extends Node2D
class_name ScreenShake

## Screen shake effect for game feel and impact
##
## Add this to your camera or main scene to enable screen shake

var shake_amount: float = 0.0
var shake_decay: float = 5.0  # How quickly shake decays
var original_position: Vector2 = Vector2.ZERO

func _ready():
	original_position = position

func _process(delta: float):
	if shake_amount > 0:
		# Apply random offset
		position = original_position + Vector2(
			randf_range(-shake_amount, shake_amount),
			randf_range(-shake_amount, shake_amount)
		)

		# Decay shake
		shake_amount = max(0, shake_amount - shake_decay * delta)
	else:
		# Return to original position
		position = original_position

func shake(amount: float, duration: float = 0.0):
	"""Trigger screen shake

	Args:
		amount: Intensity of shake in pixels
		duration: If > 0, shake will last this long. Otherwise uses decay.
	"""
	shake_amount = max(shake_amount, amount)

	if duration > 0:
		shake_decay = amount / duration

func shake_trauma(trauma: float):
	"""Shake based on trauma amount (0.0 to 1.0)

	Trauma is converted to shake amount with exponential scaling
	for better game feel.
	"""
	var amount = pow(trauma, 2) * 10.0  # Square for smoother curve
	shake(amount)
