extends Node2D

@onready var background_image = $BackgroundImage

# Background cycling variables
var background_images = []
var current_bg_index = 0
var bg_cycle_time = 2.0  # Default cycle time
var bg_cycle_timer = 0.0
var cycling_enabled = false

func _ready():
	# Connect to the start game signal to update the background
	Signals.StartRhythmGame.connect(_on_start_rhythm_game)
	Signals.EndRhythmGame.connect(_on_rhythm_game_ended)
	
	# Ensure the background image is empty at first
	clear_background()

func _process(delta):
	# Only process if cycling is enabled and we have images to cycle through
	if cycling_enabled and background_images.size() > 1:
		bg_cycle_timer += delta
		
		# Time to switch to the next image
		if bg_cycle_timer >= bg_cycle_time:
			bg_cycle_timer = 0.0
			current_bg_index = (current_bg_index + 1) % background_images.size()
			update_background_image()

func _on_start_rhythm_game(level_id):
	current_camera()
	# Get the rhythm game manager node
	var rhythm_game_manager = get_node_or_null("RhythmGameManager")
	if rhythm_game_manager == null or not level_id in rhythm_game_manager.levels:
		print("Cannot load background - missing RhythmGameManager or invalid level")
		return
	
	# Get the background image paths from the level data
	var level_data = rhythm_game_manager.levels[level_id]
	
	# Reset variables
	current_bg_index = 0
	bg_cycle_timer = 0.0
	
	# Set the cycle time from level data
	if "background_cycle_time" in level_data:
		bg_cycle_time = level_data.background_cycle_time
	else:
		bg_cycle_time = 2.0  # Default fallback
	
	# Store the background images
	if "background_images" in level_data and level_data.background_images.size() > 0:
		background_images = level_data.background_images
		cycling_enabled = true
		update_background_image()
	else:
		# Handle backward compatibility with old "background_image" field
		if "background_image" in level_data and level_data.background_image != "":
			background_images = [level_data.background_image]
			cycling_enabled = false
			update_background_image()
		else:
			background_images = []
			cycling_enabled = false
			clear_background()

func update_background_image():
	# Make sure we have images to display
	if background_images.size() == 0:
		clear_background()
		return
		
	# Get the current image to display
	var bg_path = background_images[current_bg_index]
	
	# Update the background image
	if bg_path and bg_path != "":
		#print("Displaying background image: " + bg_path)
		background_image.texture = load(bg_path)
		background_image.visible = true
	else:
		print("Invalid background image path")
		clear_background()

func clear_background():
	# Clear and hide the background image when no valid image is available
	background_images = []
	cycling_enabled = false
	background_image.texture = null
	background_image.visible = false
	
func _on_rhythm_game_ended(_success):
	# Stop the background cycling and clear the background when the game ends
	cycling_enabled = false
	clear_background()

func current_camera():
	if Signals.desired_scene =="rhythm":
		$Rhythm_camera.enabled = true
		
