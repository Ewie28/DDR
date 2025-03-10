extends Control

@onready var background_panel = $Panel
@onready var start_button = $Button 

func _ready():
	# Update the background based on current failure count
	update_failure_background()
	MusicManager.play_bedroom_music()
	update_start_button()
	# Check if we need to play a cutscene upon entering the bedroom
	CutsceneManager.check_bedroom_entry()

# Update the start button text based on the current day
func update_start_button():
	if start_button:
		start_button.text = "Day " + str(Signals.current_day)

# Disable the start button and change its text
func disable_start_button():
	start_button.text = "Game Over!"
	start_button.disabled = true

# To go to outside
func on_start_pressed() -> void:
	# Prevent scene transition if button is disabled
	if start_button.disabled:
		return
	
	Signals.transition_scene = true
	Signals.desired_scene = "outside"
	change_scene()

	
func change_scene():
	if Signals.transition_scene == true:
		if Signals.current_scene == "bedroom":
			#no need to check desired because no where else to go
			#transition happens here, add the cutscene here for when transitioning from outside to bedroom if any
			Signals.finish_change_scene() #used so bedroom can communicate with outside scene?
			get_tree().change_scene_to_file("res://scenes/outside.tscn") #this is how to change to this file

func update_failure_background():
	# Get the current style override
	var style_override = background_panel.get_theme_stylebox("panel").duplicate()
	
	# Load the appropriate failure image
	var failure_image = "res://assets/bg/fail_" + str(Signals.missions_failed) + ".png"
	
	# Check if the file exists
	if ResourceLoader.exists(failure_image):
		var texture = load(failure_image)
		style_override.texture = texture
	else:
		print("Failed to load background image: " + failure_image)
	
	# Apply the new style override
	background_panel.add_theme_stylebox_override("panel", style_override)
