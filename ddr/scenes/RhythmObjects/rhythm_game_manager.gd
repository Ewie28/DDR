extends Node

# Level data storage
var levels = {
	"rhythm1": {
		"title": "Catch the Cat",
		"music": "res://assets/audio/song_1.wav", 
		"background_image": "",  # Leave empty for now
		"note_data": "[[0.8, 1.5, 2.3],[1.0, 1.7, 2.5],[1.2, 1.9, 2.7],[1.4, 2.1, 2.9]]"
	},
	"rhythm2": {
		"title": "Clean the Cars",
		"music": "res://assets/audio/song_2.wav", 
		"background_image": "",  # Leave empty for now
		"note_data": "[[0.6, 1.2, 1.8],[0.8, 1.4, 2.0],[1.0, 1.6, 2.2],[1.2, 1.8, 2.4]]"
	},
	"rhythm3": {
		"title": "Chase the Robber",
		"music": "res://assets/audio/song_3.wav", 
		"background_image": "", 
		"note_data": "[[0.5, 1.0, 1.5],[0.7, 1.2, 1.7],[0.9, 1.4, 1.9],[1.1, 1.6, 2.1]]"
	},
	"rhythm4": {
		"title": "4",
		"music": "res://assets/audio/song_4.wav", 
		"background_image": "", 
		"note_data": "[[0.5, 1.0, 1.5],[0.7, 1.2, 1.7],[0.9, 1.4, 1.9],[1.1, 1.6, 2.1]]"
	},
	"rhythm5": {
		"title": "5",
		"music": "res://assets/audio/song_5.wav", 
		"background_image": "", 
		"note_data": "[[0.5, 1.0, 1.5],[0.7, 1.2, 1.7],[0.9, 1.4, 1.9],[1.1, 1.6, 2.1]]"
	},
	"rhythm6": {
		"title": "6",
		"music": "res://assets/audio/song_6.wav", 
		"background_image": "", 
		"note_data": "[[0.5, 1.0, 1.5],[0.7, 1.2, 1.7],[0.9, 1.4, 1.9],[1.1, 1.6, 2.1]]"
	},
	"rhythm7": {
		"title": "7",
		"music": "res://assets/audio/song_7.wav", 
		"background_image": "", 
		"note_data": "[[0.5, 1.0, 1.5],[0.7, 1.2, 1.7],[0.9, 1.4, 1.9],[1.1, 1.6, 2.1]]"
	},
	"rhythm8": {
		"title": "8",
		"music": "res://assets/audio/song_8.wav", 
		"background_image": "", 
		"note_data": "[[0.5, 1.0, 1.5],[0.7, 1.2, 1.7],[0.9, 1.4, 1.9],[1.1, 1.6, 2.1]]"
	},
	"rhythm9": {
		"title": "9",
		"music": "res://assets/audio/song_9.wav", 
		"background_image": "", 
		"note_data": "[[0.5, 1.0, 1.5],[0.7, 1.2, 1.7],[0.9, 1.4, 1.9],[1.1, 1.6, 2.1]]"
	}
}

# Currently active level
var current_level = ""
var game_in_progress = false

# Connect to necessary signals
func _ready():
	# Connect to signals
	Signals.StartRhythmGame.connect(start_rhythm_game)
	print("RhythmGameManager ready and signals connected")

# Function to start a rhythm game level
func start_rhythm_game(level_id):
	print("RhythmGameManager received start request for: " + level_id)
	
	if level_id in levels:
		current_level = level_id
		game_in_progress = true
		
		# Get the level editor node
		var level_editor = get_node_or_null("../LevelEditor")
		if level_editor == null:
			print("ERROR: Could not find Level editor node!")
			return
			
		print("Found level editor, loading level data")
		
		# Call the level editor's load method directly
		level_editor.load_rhythm_level(levels[level_id])
	else:
		print("Error: Level " + level_id + " not found!")
