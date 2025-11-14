extends CPUParticles2D
class_name CollisionParticles

## Particle effect for block collisions

func _ready():
	# Configure particle appearance
	emitting = false
	one_shot = true
	explosiveness = 0.8
	amount = 20
	lifetime = 0.8
	speed_scale = 2.0

	# Emission shape
	emission_shape = EMISSION_SHAPE_SPHERE
	emission_sphere_radius = 10.0

	# Particle properties
	direction = Vector2(0, -1)
	spread = 180.0
	gravity = Vector2(0, 200)
	initial_velocity_min = 100.0
	initial_velocity_max = 200.0

	# Appearance
	scale_amount_min = 3.0
	scale_amount_max = 6.0
	color = Color.RED

func play_effect(pos: Vector2) -> void:
	"""Play the collision effect at a position"""
	global_position = pos
	emitting = true

	# Auto-cleanup after animation
	await get_tree().create_timer(lifetime).timeout
	queue_free()
