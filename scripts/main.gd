extends Node2D

## Main game controller
##
## Manages game state, spawning, scoring, difficulty, and coordination
## between all game systems.

# Preload scenes
const PLAYER_SCENE = preload("res://scenes/player/player.tscn")
const BLOCK_SCENE = preload("res://scenes/block/block.tscn")

# Game configuration
const BASE_SPAWN_INTERVAL = 1.0
const MIN_SPAWN_INTERVAL = 0.3
const DIFFICULTY_INCREASE_RATE = 0.95  # Multiplier per level
const DIFFICULTY_LEVEL_TIME = 10.0  # Seconds per difficulty level

# Game state
var player: Player
var blocks: Array[Block] = []
var game_active: bool = false
var game_paused: bool = false

# Scoring and difficulty
var score: int = 0
var high_score: int = 0
var survival_time: float = 0.0
var difficulty_level: int = 1
var difficulty_multiplier: float = 1.0

# Spawning
var spawn_interval: float = BASE_SPAWN_INTERVAL
var time_since_last_spawn: float = 0.0

# UI references
@onready var hud: HUD = $HUD
@onready var game_over_screen: GameOverScreen = $GameOverScreen
@onready var start_menu: StartMenu = $StartMenu
@onready var pause_menu: CanvasLayer = $PauseMenu

func _ready():
	load_high_score()
	setup_ui()
	# Game starts when player presses start on menu

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
	game_active = true
	game_paused = false

	# Create player
	player = PLAYER_SCENE.instantiate()
	add_child(player)

	# Update UI
	hud.update_score(score)
	hud.update_high_score(high_score)
	hud.update_time(survival_time)
	hud.update_difficulty(difficulty_level)

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

func _process(delta: float) -> void:
	if not game_active or game_paused:
		return

	update_survival_time(delta)
	update_difficulty(delta)
	spawn_blocks(delta)
	update_blocks(delta)

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
	else:
		Engine.time_scale = 1.0

func update_survival_time(delta: float) -> void:
	"""Update and display survival time"""
	survival_time += delta
	hud.update_time(survival_time)

func update_difficulty(delta: float) -> void:
	"""Gradually increase game difficulty"""
	var new_level = int(survival_time / DIFFICULTY_LEVEL_TIME) + 1

	if new_level > difficulty_level:
		difficulty_level = new_level
		difficulty_multiplier = pow(1.15, difficulty_level - 1)

		# Decrease spawn interval (more blocks)
		spawn_interval = max(
			MIN_SPAWN_INTERVAL,
			BASE_SPAWN_INTERVAL * pow(DIFFICULTY_INCREASE_RATE, difficulty_level - 1)
		)

		hud.update_difficulty(difficulty_level)

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

		# Apply difficulty scaling
		block.set_difficulty_multiplier(difficulty_multiplier)

		blocks.append(block)

func update_blocks(delta: float) -> void:
	"""Update all blocks and check for collisions"""
	var player_rect = player.get_collision_rect()

	# Check collisions and cleanup
	for i in range(blocks.size() - 1, -1, -1):
		var block = blocks[i]

		# Check if block is still valid
		if not is_instance_valid(block):
			blocks.remove_at(i)
			continue

		# Check collision with player
		if block.get_collision_rect().intersects(player_rect):
			end_game()
			return

		# Award points for blocks that pass the player
		if block.position.y > player.position.y + player.size.y and block.get_meta("scored", false) == false:
			block.set_meta("scored", true)
			add_score(10)

		# Remove blocks that are off screen
		if block.position.y > get_viewport_rect().size.y + 50:
			block.queue_free()
			blocks.remove_at(i)

func add_score(points: int) -> void:
	"""Add points to the score"""
	score += points
	hud.update_score(score)

func end_game() -> void:
	"""End the game and show game over screen"""
	game_active = false

	# Update high score if needed
	if score > high_score:
		high_score = score
		save_high_score()

	# Show game over screen
	game_over_screen.show_game_over(score, survival_time, high_score)

func save_high_score() -> void:
	"""Save high score to file"""
	var file = FileAccess.open("user://high_score.save", FileAccess.WRITE)
	if file:
		file.store_32(high_score)
		file.close()

func load_high_score() -> void:
	"""Load high score from file"""
	if FileAccess.file_exists("user://high_score.save"):
		var file = FileAccess.open("user://high_score.save", FileAccess.READ)
		if file:
			high_score = file.get_32()
			file.close()
