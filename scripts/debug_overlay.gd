extends CanvasLayer
class_name DebugOverlay

## Debug overlay for development and testing
##
## Press F3 to toggle
## Shows FPS, node count, and other debug info

var visible_debug = false

@onready var debug_label = $DebugLabel

func _ready():
	hide()

func _input(event):
	"""Toggle debug overlay with F3"""
	if event.is_action_pressed("toggle_debug"):
		visible_debug = not visible_debug
		visible = visible_debug

func _process(_delta):
	if visible_debug:
		_update_debug_info()

func _update_debug_info():
	"""Update debug information display"""
	var fps = Engine.get_frames_per_second()
	var mem = OS.get_static_memory_usage() / 1048576.0  # Convert to MB
	var nodes = get_tree().get_node_count()

	var debug_text = ""
	debug_text += "FPS: %d\n" % fps
	debug_text += "Memory: %.2f MB\n" % mem
	debug_text += "Nodes: %d\n" % nodes
	debug_text += "Time Scale: %.2fx\n" % Engine.time_scale

	# Add game-specific debug info if in game
	var main = get_tree().get_first_node_in_group("main_game")
	if main:
		debug_text += "\n--- GAME ---\n"
		debug_text += "Score: %d\n" % main.score
		debug_text += "Level: %d\n" % main.difficulty_level
		debug_text += "Blocks: %d\n" % main.blocks.size()
		debug_text += "Difficulty: %.2fx\n" % main.difficulty_multiplier

	debug_label.text = debug_text
