extends Node2D

# Set to true when in level creation mode
const in_edit_mode: bool = false

# Current level being played
var current_level_name = ""

# Time it takes for falling keys to reach critical point
var fk_fall_time: float = 2.43323599

# Array for recording key presses in edit mode
var fk_output_arr = [[],[],[],[]]

# Signal connections and initial setup
func _ready():
	if in_edit_mode:
		Signals.KeyListnerPress.connect(KeyListenerPress)
	
	print("LevelEditor ready")

# Load a rhythm level when requested
func load_rhythm_level(level_data):
	print("Loading rhythm level: " + level_data.title)
	current_level_name = level_data.title
	
	# Set up the music
	$SongPlayer.stream = load(level_data.music)
	
	# Parse the note data
	var note_data = str_to_var(level_data.note_data)
	
	# Find the RhythmUI
	var rhythm_ui = get_node_or_null("../../Levels//RhythmUI/rhythm_ui")
	if rhythm_ui != null and rhythm_ui.has_method("reset_score"):
		rhythm_ui.reset_score()
	else:
		print("Could not find RhythmUI or it doesn't have reset_score method")
	
	# Start the music
	print("Starting music playback")
	$SongPlayer.play()
	
	# Spawn the falling keys based on timing data
	var button_names = ["button_LEFT", "button_DOWN", "button_UP", "button_RIGHT"]
	
	for i in range(note_data.size()):
		if i < button_names.size():  # Make sure we don't go out of bounds
			var button_name = button_names[i]
			for delay in note_data[i]:
				spawn_falling_key(button_name, delay)

# Function for recording key presses in edit mode
func KeyListenerPress(button_name: String, array_num: int):
	if in_edit_mode:
		fk_output_arr[array_num].append($SongPlayer.get_playback_position() - fk_fall_time)

# Spawn a falling key after the specified delay
func spawn_falling_key(button_name: String, delay: float):
	#print("Scheduling key spawn: " + button_name + " after " + str(delay) + " seconds")
	await get_tree().create_timer(delay).timeout
	#print("Spawning falling key: " + button_name)
	Signals.CreateFallingKey.emit(button_name)

# When the song finishes, end the rhythm game
func _on_song_player_finished() -> void:
	print("Song finished")
	if in_edit_mode:
		print(fk_output_arr)
	else:
		# Determine if the player passed the level
		var rhythm_ui = get_node_or_null("../../Levels//RhythmUI/rhythm_ui")
		var success = false
		if rhythm_ui != null:
			success = rhythm_ui.score >= 500  # Lower threshold for testing
			print("Final score: " + str(rhythm_ui.score))
		
		# Wait a moment before ending
		await get_tree().create_timer(1).timeout
		
		# End the rhythm game
		print("Emitting EndRhythmGame signal")
		Signals.EndRhythmGame.emit(success)
