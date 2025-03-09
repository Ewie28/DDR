extends Control

# Reference to the rhythm level selection buttons
@onready var level_buttons = $LevelButtons

# Reference to the BaseRhythm scene (preload it)
@onready var base_rhythm_scene = preload("res://scenes/Rhythms/BaseRhythm.tscn")
var base_rhythm_instance = null

# Setup the test scene
func _ready():
	# Connect each button to start the corresponding level
	for button in level_buttons.get_children():
		button.pressed.connect(_on_level_button_pressed.bind(button.name))
	
	# Connect to the rhythm game end signal
	Signals.EndRhythmGame.connect(_on_rhythm_game_ended)
	
	# Connect to the new rhythm game result signal
	Signals.RhythmGameResult.connect(_on_rhythm_game_result)

# When a level button is pressed
func _on_level_button_pressed(button_name):
	var level_id = button_name.replace("Button", "").to_lower()
	print("Starting rhythm level: " + level_id)
	
	# Hide the test UI
	visible = false
	
	# Instantiate the BaseRhythm scene if it doesn't exist
	if base_rhythm_instance == null:
		base_rhythm_instance = base_rhythm_scene.instantiate()
		get_parent().add_child(base_rhythm_instance)
	
	# Wait a frame to ensure the scene is ready
	await get_tree().process_frame
	
	# Start the selected rhythm game
	Signals.StartRhythmGame.emit(level_id)

# Handle the result signal
func _on_rhythm_game_result(score, success):
	print("(rhythm_test_scene)Rhythm game completed with score: " + str(score))
	print("Player " + ("PASSED" if success else "FAILED") + " the level")


# Show this scene again when a rhythm game ends
func _on_rhythm_game_ended(_success):
	if _success:
		print("game end")
	else:
		print("game crashed")
	
	# Show the test UI again
	visible = true
	
	# Remove the rhythm game instance
	if base_rhythm_instance != null:
		base_rhythm_instance.queue_free()
		base_rhythm_instance = null
