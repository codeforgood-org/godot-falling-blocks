extends Node2D

## Main game controller
##
## Manages game state, spawning, scoring, difficulty, and coordination
## between all game systems including power-ups, combos, and achievements.

# Preload scenes
const PLAYER_SCENE = preload("res://scenes/player/player.tscn")
const BLOCK_SCENE = preload("res://scenes/block/block.tscn")
const POWERUP_SCENE = preload("res://scenes/powerup/powerup.tscn")

# Game configuration
const BASE_SPAWN_INTERVAL = 1.0
const MIN_SPAWN_INTERVAL = 0.3
const DIFFICULTY_INCREASE_RATE = 0.95  # Multiplier per level
const DIFFICULTY_LEVEL_TIME = 10.0  # Seconds per difficulty level
const POWERUP_SPAWN_CHANCE = 0.15  # 15% chance to spawn power-up
const POWERUP_SPAWN_INTERVAL = 8.0  # Minimum seconds between power-ups

# Game state
var player: Player
var blocks: Array[Block] = []
var powerups: Array = []
var game_active: bool = false
var game_paused: bool = false

# Scoring and difficulty
var score: int = 0
var high_score: int = 0
var survival_time: float = 0.0
var difficulty_level: int = 1
var difficulty_multiplier: float = 1.0
var blocks_dodged: int = 0

# Spawning
var spawn_interval: float = BASE_SPAWN_INTERVAL
var time_since_last_spawn: float = 0.0
var time_since_last_powerup: float = 0.0

# Power-up system
var active_powerups: Dictionary = {}  # PowerUpType -> time_remaining

# Combo system
var combo_system: ComboSystem

# Screen shake
var screen_shake: ScreenShake

# UI references
@onready var hud: HUD = $HUD
@onready var game_over_screen: GameOverScreen = $GameOverScreen
@onready var start_menu: StartMenu = $StartMenu
@onready var pause_menu: CanvasLayer = $PauseMenu

func _ready():
	add_to_group("main_game")  # For debug overlay
	load_high_score()
	setup_systems()
	setup_ui()

func setup_systems() -> void:
	"""Initialize game systems"""
	# Create combo system
	combo_system = ComboSystem.new()
	add_child(combo_system)
	combo_system.combo_changed.connect(_on_combo_changed)
	combo_system.multiplier_increased.connect(_on_multiplier_increased)

	# Create screen shake
	screen_shake = ScreenShake.new()
	add_child(screen_shake)

func setup_ui() -> void:
	"""Connect UI signals"""
	start_menu.start_requested.connect(_on_start_requested)
	game_over_screen.restart_requested.connect(_on_restart_requested)

	hud.update_score(score)
	hud.update_high_score(high_score)
	hud.update_time(survival_time)
	hud.update_difficulty(difficulty_level)

func _on_start_requested() -> void:
	"""Start a new game"""
	start_game()

func _on_restart_requested() -> void:
	"""Restart the game after game over"""
	start_game()

func start_game() -> void:
	"""Initialize and start a new game"""
	# Clear existing game state
	clear_game()

	# Reset game variables
	score = 0
	survival_time = 0.0
	difficulty_level = 1
	difficulty_multiplier = 1.0
	spawn_interval = BASE_SPAWN_INTERVAL
	time_since_last_spawn = 0.0
	time_since_last_powerup = 0.0
	blocks_dodged = 0
	game_active = true
	game_paused = false
	active_powerups.clear()

	# Reset combo system
	if combo_system:
		combo_system.break_combo()

	# Create player
	player = PLAYER_SCENE.instantiate()
	add_child(player)

	# Update UI
	hud.update_score(score)
	hud.update_high_score(high_score)
	hud.update_time(survival_time)
	hud.update_difficulty(difficulty_level)
	hud.update_combo(0, 1.0)
	hud.clear_active_powerups()

	# Play game start sound
	if AudioManager:
		AudioManager.play_sfx("game_start")

func clear_game() -> void:
	"""Clear all game objects"""
	# Remove player
	if player:
		player.queue_free()
		player = null

	# Remove all blocks
	for block in blocks:
		if is_instance_valid(block):
			block.queue_free()
	blocks.clear()

	# Remove all power-ups
	for powerup in powerups:
		if is_instance_valid(powerup):
			powerup.queue_free()
	powerups.clear()

func _process(delta: float) -> void:
	if not game_active or game_paused:
		return

	update_survival_time(delta)
	update_difficulty(delta)
	update_powerups(delta)
	spawn_blocks(delta)
	spawn_powerups(delta)
	update_blocks(delta)
	update_powerup_collectibles(delta)

	# Update combo system timer
	if combo_system:
		combo_system._process(delta)

func _input(event: InputEvent) -> void:
	"""Handle game-level input"""
	if event.is_action_pressed("pause") and game_active:
		toggle_pause()

func toggle_pause() -> void:
	"""Toggle game pause state"""
	game_paused = not game_paused
	pause_menu.visible = game_paused

	if game_paused:
		Engine.time_scale = 0.0
		if AudioManager:
			AudioManager.play_sfx("pause")
	else:
		Engine.time_scale = 1.0

func update_survival_time(delta: float) -> void:
	"""Update and display survival time"""
	survival_time += delta
	hud.update_time(survival_time)

	# Check survival achievements
	if int(survival_time) == 60:
		Achievements.check_achievement("survive_60")
	elif int(survival_time) == 120:
		Achievements.check_achievement("survive_120")
	elif int(survival_time) == 300:
		Achievements.check_achievement("survive_300")

func update_difficulty(delta: float) -> void:
	"""Gradually increase game difficulty"""
	var new_level = int(survival_time / DIFFICULTY_LEVEL_TIME) + 1

	if new_level > difficulty_level:
		difficulty_level = new_level
		difficulty_multiplier = pow(1.15, difficulty_level - 1)

		# Apply difficulty preset modifier
		var preset = GameManager.settings.get("difficulty_preset", "Normal")
		match preset:
			"Easy": difficulty_multiplier *= 0.7
			"Hard": difficulty_multiplier *= 1.3
			"Extreme": difficulty_multiplier *= 1.6

		# Decrease spawn interval (more blocks)
		spawn_interval = max(
			MIN_SPAWN_INTERVAL,
			BASE_SPAWN_INTERVAL * pow(DIFFICULTY_INCREASE_RATE, difficulty_level - 1)
		)

		hud.update_difficulty(difficulty_level)

		# Play level up sound
		if AudioManager:
			AudioManager.play_sfx("level_up")

		# Check level achievements
		if difficulty_level == 5:
			Achievements.check_achievement("level_5")
		elif difficulty_level == 10:
			Achievements.check_achievement("level_10")

func spawn_blocks(delta: float) -> void:
	"""Spawn falling blocks at intervals"""
	time_since_last_spawn += delta

	if time_since_last_spawn >= spawn_interval:
		time_since_last_spawn = 0.0

		# Create new block
		var block = BLOCK_SCENE.instantiate()
		add_child(block)

		# Set random spawn position
		var viewport_size = get_viewport_rect().size
		var spawn_x = randf_range(0, viewport_size.x - block.size.x)
		block.position = Vector2(spawn_x, -block.size.y)

		# Apply difficulty scaling and power-up effects
		var speed_mult = difficulty_multiplier
		if has_active_powerup(PowerUp.PowerUpType.SLOW_MOTION):
			speed_mult *= 0.5  # Slow motion effect

		block.set_difficulty_multiplier(speed_mult)
		blocks.append(block)

		# Play spawn sound
		if AudioManager:
			AudioManager.play_sfx("block_spawn")

func spawn_powerups(delta: float) -> void:
	"""Occasionally spawn power-ups"""
	time_since_last_powerup += delta

	if time_since_last_powerup >= POWERUP_SPAWN_INTERVAL:
		if randf() < POWERUP_SPAWN_CHANCE:
			time_since_last_powerup = 0.0

			# Create power-up
			var powerup = POWERUP_SCENE.instantiate()
			add_child(powerup)

			# Set random spawn position
			var viewport_size = get_viewport_rect().size
			var spawn_x = randf_range(0, viewport_size.x - powerup.size.x)
			powerup.position = Vector2(spawn_x, -powerup.size.y)

			powerups.append(powerup)

func update_blocks(delta: float) -> void:
	"""Update all blocks and check for collisions"""
	if not player:
		return

	var player_rect = player.get_collision_rect()
	var has_shield = has_active_powerup(PowerUp.PowerUpType.SHIELD)

	# Check collisions and cleanup
	for i in range(blocks.size() - 1, -1, -1):
		var block = blocks[i]

		# Check if block is still valid
		if not is_instance_valid(block):
			blocks.remove_at(i)
			continue

		# Check collision with player
		if block.get_collision_rect().intersects(player_rect):
			if has_shield:
				# Shield protects - destroy block instead
				block.queue_free()
				blocks.remove_at(i)
				screen_shake.shake(5.0, 0.2)
				if AudioManager:
					AudioManager.play_sfx("block_destroyed")
				continue
			else:
				# Game over
				end_game()
				return

		# Award points for blocks that pass the player
		if block.position.y > player.position.y + player.size.y and block.get_meta("scored", false) == false:
			block.set_meta("scored", true)
			blocks_dodged += 1

			# Register dodge with combo system
			if combo_system:
				combo_system.register_dodge()

			# Calculate points with multipliers
			var base_points = 10
			var combo_mult = combo_system.combo_multiplier if combo_system else 1.0
			var powerup_mult = 2.0 if has_active_powerup(PowerUp.PowerUpType.SCORE_MULTIPLIER) else 1.0
			var points = int(base_points * combo_mult * powerup_mult)

			add_score(points)

			# Play dodge sound
			if AudioManager:
				AudioManager.play_sfx("block_pass")

		# Remove blocks that are off screen
		if block.position.y > get_viewport_rect().size.y + 50:
			block.queue_free()
			blocks.remove_at(i)

func update_powerup_collectibles(delta: float) -> void:
	"""Check for power-up collection"""
	if not player:
		return

	var player_rect = player.get_collision_rect()

	for i in range(powerups.size() - 1, -1, -1):
		var powerup = powerups[i]

		if not is_instance_valid(powerup):
			powerups.remove_at(i)
			continue

		# Check collection
		if powerup.get_collision_rect().intersects(player_rect):
			collect_powerup(powerup)
			powerup.queue_free()
			powerups.remove_at(i)

		# Remove if off screen
		elif powerup.position.y > get_viewport_rect().size.y + 50:
			powerup.queue_free()
			powerups.remove_at(i)

func collect_powerup(powerup: PowerUp) -> void:
	"""Collect a power-up"""
	activate_powerup(powerup.type, powerup.get_duration())

	# Apply immediate effects
	match powerup.type:
		PowerUp.PowerUpType.SHRINK:
			if player:
				player.size = Vector2(30, 30)  # Shrink player

	hud.add_active_powerup(powerup.get_type_name(), powerup.get_duration())

	# Play collection sound
	if AudioManager:
		AudioManager.play_sfx("powerup_collect")

	# Track statistics
	Statistics.record_powerup_collected()

func activate_powerup(type: PowerUp.PowerUpType, duration: float) -> void:
	"""Activate a power-up effect"""
	active_powerups[type] = duration

func has_active_powerup(type: PowerUp.PowerUpType) -> bool:
	"""Check if a power-up type is currently active"""
	return type in active_powerups and active_powerups[type] > 0

func update_powerups(delta: float) -> void:
	"""Update active power-up timers"""
	var expired = []

	for type in active_powerups:
		active_powerups[type] -= delta
		if active_powerups[type] <= 0:
			expired.append(type)

	# Remove expired power-ups
	for type in expired:
		deactivate_powerup(type)
		active_powerups.erase(type)

func deactivate_powerup(type: PowerUp.PowerUpType) -> void:
	"""Deactivate a power-up when it expires"""
	match type:
		PowerUp.PowerUpType.SHRINK:
			if player:
				player.size = Vector2(50, 50)  # Restore original size

func add_score(points: int) -> void:
	"""Add points to the score"""
	score += points
	hud.update_score(score)

	# Check score achievements
	if score >= 100:
		Achievements.check_achievement("score_100")
	if score >= 500:
		Achievements.check_achievement("score_500")
	if score >= 1000:
		Achievements.check_achievement("score_1000")
	if score >= 5000:
		Achievements.check_achievement("score_5000")

func _on_combo_changed(combo_count: int) -> void:
	"""Handle combo count changes"""
	var multiplier = combo_system.combo_multiplier if combo_system else 1.0
	hud.update_combo(combo_count, multiplier)

	# Check combo achievements
	if combo_count == 10:
		Achievements.check_achievement("combo_10")
	elif combo_count == 50:
		Achievements.check_achievement("combo_50")
	elif combo_count == 100:
		Achievements.check_achievement("combo_100")

func _on_multiplier_increased(multiplier: float) -> void:
	"""Handle score multiplier increases"""
	if AudioManager:
		AudioManager.play_sfx("combo_level_up")

func end_game() -> void:
	"""End the game and show game over screen"""
	game_active = false

	# Screen shake on death
	screen_shake.shake(20.0, 0.5)

	# Play game over sound
	if AudioManager:
		AudioManager.play_sfx("game_over")

	# Update high score if needed
	if score > high_score:
		high_score = score
		save_high_score()

	# Record statistics
	var best_combo = combo_system.current_combo if combo_system else 0
	Statistics.record_game_end(score, survival_time, difficulty_level, blocks_dodged, best_combo)

	# Show game over screen
	game_over_screen.show_game_over(score, survival_time, high_score)

func save_high_score() -> void:
	"""Save high score using GameManager"""
	if GameManager:
		GameManager.high_score = high_score
		GameManager.save_game_data()

func load_high_score() -> void:
	"""Load high score from GameManager"""
	if GameManager:
		high_score = GameManager.high_score
