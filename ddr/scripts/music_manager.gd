extends Node

# Audio player nodes
var bedroom_music_player: AudioStreamPlayer
var outside_music_player: AudioStreamPlayer

# Music file paths
var bedroom_music_path = "res://assets/audio/bedroom_music.wav"
var outside_music_path = "res://assets/audio/outside_music.wav"

# Track current scene for music management
var current_scene_music = ""

func _ready():
	# Create audio players
	bedroom_music_player = AudioStreamPlayer.new()
	outside_music_player = AudioStreamPlayer.new()
	
	# Add them as children to this node
	add_child(bedroom_music_player)
	add_child(outside_music_player)
	
	# Set up the music streams
	bedroom_music_player.stream = load(bedroom_music_path)
	outside_music_player.stream = load(outside_music_path)
	
	# Configure them to loop
	bedroom_music_player.bus = "Music"
	outside_music_player.bus = "Music"
	
	# Connect to scene transition signals
	Signals.StartRhythmGame.connect(_on_rhythm_game_start)
	Signals.EndRhythmGame.connect(_on_rhythm_game_end)
	
	print("Music Manager initialized")

# Function to play bedroom music
func play_bedroom_music():
	if current_scene_music != "bedroom":
		# Stop other music
		outside_music_player.stop()
		
		# Start bedroom music if not already playing
		if !bedroom_music_player.playing:
			bedroom_music_player.play()
			
		current_scene_music = "bedroom"
		print("Playing bedroom music")

# Function to play outside music
func play_outside_music():
	if current_scene_music != "outside":
		# Stop other music
		bedroom_music_player.stop()
		
		# Start outside music if not already playing
		if !outside_music_player.playing:
			outside_music_player.play()
			
		current_scene_music = "outside"
		print("Playing outside music")

# Function to stop all music
func stop_all_music():
	bedroom_music_player.stop()
	outside_music_player.stop()
	current_scene_music = ""
	print("All music stopped")

# Rhythm game start - stop current music
func _on_rhythm_game_start(_level_id):
	stop_all_music()
	print("Music stopped for rhythm game")

# Rhythm game end - resume appropriate music
func _on_rhythm_game_end(_success):
	play_outside_music()
	print("Resuming music after rhythm game")
