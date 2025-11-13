extends Node

## Global audio manager for all game sounds and music
##
## Centralized system for playing sound effects and music with volume control.
## Automatically creates audio players as needed and manages audio settings.

# Audio bus names
const MUSIC_BUS = "Music"
const SFX_BUS = "SFX"

# Audio player pools
var music_player: AudioStreamPlayer
var sfx_players: Array[AudioStreamPlayer] = []
const MAX_SFX_PLAYERS = 8

# Volume settings (0.0 to 1.0)
var music_volume: float = 0.7:
	set(value):
		music_volume = clamp(value, 0.0, 1.0)
		_update_music_volume()

var sfx_volume: float = 0.8:
	set(value):
		sfx_volume = clamp(value, 0.0, 1.0)
		_update_sfx_volume()

# Sound library paths (placeholders - replace with actual audio files)
var sounds = {
	"block_spawn": "",
	"block_pass": "",
	"collision": "",
	"game_over": "",
	"level_up": "",
	"menu_select": "",
	"menu_navigate": "",
	"pause": "",
	"score": "",
	"powerup_collect": "",
	"powerup_activate": "",
}

var music_tracks = {
	"menu": "",
	"gameplay": "",
	"game_over": "",
}

func _ready():
	# Create music player
	music_player = AudioStreamPlayer.new()
	music_player.bus = MUSIC_BUS
	add_child(music_player)

	# Create SFX player pool
	for i in range(MAX_SFX_PLAYERS):
		var player = AudioStreamPlayer.new()
		player.bus = SFX_BUS
		add_child(player)
		sfx_players.append(player)

	# Initialize volume
	_update_music_volume()
	_update_sfx_volume()

func play_sfx(sound_name: String) -> void:
	"""Play a sound effect by name"""
	if sound_name not in sounds:
		push_warning("Sound '%s' not found in library" % sound_name)
		return

	var sound_path = sounds[sound_name]
	if sound_path == "":
		# Placeholder - sound file not yet added
		return

	# Find available player
	var player = _get_available_sfx_player()
	if player and ResourceLoader.exists(sound_path):
		player.stream = load(sound_path)
		player.play()

func play_music(track_name: String, loop: bool = true) -> void:
	"""Play a music track by name"""
	if track_name not in music_tracks:
		push_warning("Music track '%s' not found" % track_name)
		return

	var track_path = music_tracks[track_name]
	if track_path == "":
		# Placeholder - music file not yet added
		return

	if ResourceLoader.exists(track_path):
		music_player.stream = load(track_path)
		# Note: Set loop property on the AudioStream resource itself
		music_player.play()

func stop_music(fade_time: float = 0.0) -> void:
	"""Stop the currently playing music"""
	if fade_time > 0.0:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80, fade_time)
		tween.tween_callback(music_player.stop)
		tween.tween_callback(func(): music_player.volume_db = 0)
	else:
		music_player.stop()

func _get_available_sfx_player() -> AudioStreamPlayer:
	"""Find an available SFX player from the pool"""
	for player in sfx_players:
		if not player.playing:
			return player
	# All players busy, use the first one
	return sfx_players[0]

func _update_music_volume() -> void:
	"""Update the music volume"""
	if music_player:
		music_player.volume_db = linear_to_db(music_volume)

func _update_sfx_volume() -> void:
	"""Update the SFX volume"""
	for player in sfx_players:
		player.volume_db = linear_to_db(sfx_volume)

func set_music_enabled(enabled: bool) -> void:
	"""Enable or disable music"""
	music_volume = 0.7 if enabled else 0.0

func set_sfx_enabled(enabled: bool) -> void:
	"""Enable or disable sound effects"""
	sfx_volume = 0.8 if enabled else 0.0
