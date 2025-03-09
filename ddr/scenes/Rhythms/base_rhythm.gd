extends Node2D
@onready var background_image = $BackgroundImage  # Reference to the TextureRect

func _ready():
	# Connect to the start game signal to update the background
	Signals.StartRhythmGame.connect(_on_start_rhythm_game)
	Signals.EndRhythmGame.connect(_on_rhythm_game_ended)
	
	# Ensure the background image is empty at first
	clear_background()

func _on_start_rhythm_game(level_id):
	# Get the rhythm game manager node
	var rhythm_game_manager = get_node_or_null("RhythmGameManager")
	if rhythm_game_manager == null or not level_id in rhythm_game_manager.levels:
		print("Cannot load background - missing RhythmGameManager or invalid level")
		return
	
	# Get the background image path from the level data
	var level_data = rhythm_game_manager.levels[level_id]
	var bg_path = level_data.background_image
	
	# Update the background image
	if bg_path and bg_path != "":
		print("Loading background image: " + bg_path)
		background_image.texture = load(bg_path)
		background_image.visible = true
	else:
		print("No background image specified for level: " + level_id)
		clear_background()

func clear_background():
	# Clear and hide the background image when no valid image is available
	background_image.texture = null
	background_image.visible = false
	
func _on_rhythm_game_ended(_success):
	# Clear the background when the game ends
	clear_background()
