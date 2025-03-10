extends Node

@onready var background_panel = $Panel

# Cutscene data - each cutscene is a list of scenes with image and text
var cutscenes = {
	"day1_intro": [
		{"image": "res://assets/cutscenes/day1/image1.png", "text": "Day 1 ..."},
		{"image": "res://assets/cutscenes/day1/image2.png", "text": "gotta make money"},
		{"image": "res://assets/cutscenes/day1/blue.jpg", "text": "can't wait"}
		# Add more frames as needed
	],
	"day1_to_day2": [
		{"image": "res://assets/cutscenes/day1_end/image1.png", "text": "today i managed to cover these bills"},
		{"image": "res://assets/cutscenes/day1_end/image2.png", "text": "i wonder what tomorrow brings"},
		# Add more frames as needed
	],
	"day2_to_day3": [
		{"image": "res://assets/cutscenes/day2_end/image1.png", "text": "today i managed to cover these bills"},
		{"image": "res://assets/cutscenes/day2_end/image2.png", "text": "i wonder what tomorrow brings"},
		# Add more frames as needed
	],
	"good_ending": [
		{"image": "res://assets/cutscenes/good_end/image1.png", "text": "im pretty good at odd jobs"},
		{"image": "res://assets/cutscenes/good_end/image2.png", "text": "game over"},
		# Add more frames as needed
	],
	"bad_ending": [
		{"image": "res://assets/cutscenes/bad_end/image1.png", "text": "Oh no! You've failed too many times..."},
		{"image": "res://assets/cutscenes/bad_end/image2.png", "text": "game over"},
		# Add more frames as needed
	]
}

# References to UI elements inside Bedroom scene
var cutscene_panel
var cutscene_image
var cutscene_text
var next_button

# Cutscene state
var current_cutscene = []
var current_frame = 0
var is_in_cutscene = false
var is_ending = false

func _ready():
	# Refresh UI references whenever the scene is ready
	find_ui_elements()
	print("Cutscene Manager initialized")

# Find and update the UI references
func find_ui_elements():
	# Get current bedroom scene
	var bedroom = get_tree().current_scene
	
	# If bedroom doesn't have the cutscene panel, don't do anything
	if not bedroom.has_node("CutscenePanel"):
		print("CutscenePanel not found in the current scene")
		return
	
	# Refresh UI references
	cutscene_panel = bedroom.get_node("CutscenePanel")
	cutscene_image = cutscene_panel.get_node("CutsceneImage")
	cutscene_text = cutscene_panel.get_node("CutsceneText")
	next_button = cutscene_panel.get_node("NextButton")

	# Connect button signal again to avoid duplicate connections
	next_button.pressed.disconnect(_on_next_button_pressed)
	next_button.pressed.connect(_on_next_button_pressed)

	print("Cutscene UI references updated")

# Check if we should play a cutscene when entering the bedroom
func check_bedroom_entry():
	if is_in_cutscene:
		return
	
	if Signals.current_day == 1 and Signals.missions_attempted == 0:
		call_deferred("play_cutscene", "day1_intro")
		return
	
	if Signals.missions_failed >= Signals.MAX_FAILURES:
		#get_tree().create_timer(2.0).timeout.connect(func(): call_deferred("play_cutscene", "bad_ending", true))
		call_deferred("play_cutscene", "bad_ending", true)
		return
	
	if Signals.current_day == 2 and Signals.missions_attempted == 0:
		call_deferred("play_cutscene", "day1_to_day2")
		return
	
	if Signals.current_day == 3 and Signals.missions_attempted == 0:
		call_deferred("play_cutscene", "day2_to_day3")
		return
		
	if Signals.current_day == 4 and Signals.missions_attempted == 0:
		call_deferred("play_cutscene", "good_ending", true)
		return

	#if Signals.missions_attempted >= Signals.MAX_MISSIONS:
		#var callback = func():
			#if Signals.current_day == 1:
				#call_deferred("play_cutscene", "day1_to_day2")
			#elif Signals.current_day == 2:
				#call_deferred("play_cutscene", "good_ending", true)
		#get_tree().create_timer(2.0).timeout.connect(callback)

# Play a cutscene
func play_cutscene(cutscene_name, is_ending_cutscene = false):
	find_ui_elements()  # Refresh references before using them

	if not cutscene_name in cutscenes:
		print("Cutscene not found: " + cutscene_name)
		return
	
	is_in_cutscene = true
	is_ending = is_ending_cutscene
	
	if has_node("/root/MusicManager"):
		get_node("/root/MusicManager").stop_all_music()
	
	current_cutscene = cutscenes[cutscene_name]
	current_frame = 0
	cutscene_panel.visible = true  # Now this won't error!

	show_current_frame()
	print("Playing cutscene: " + cutscene_name)

# Show the current frame of the active cutscene
func show_current_frame():
	if current_frame < current_cutscene.size():
		var frame = current_cutscene[current_frame]
		cutscene_image.texture = load(frame["image"])
		cutscene_text.text = frame["text"]
	else:
		end_cutscene()

# Handle next button press
func _on_next_button_pressed():
	current_frame += 1
	if current_frame < current_cutscene.size():
		show_current_frame()
	else:
		end_cutscene()

# End the current cutscene
func end_cutscene():
	cutscene_panel.visible = false
	is_in_cutscene = false

	if not is_ending:
		if Signals.missions_attempted >= Signals.MAX_MISSIONS:
			Signals.next_day()
		if has_node("/root/MusicManager"):
			get_node("/root/MusicManager").play_bedroom_music()
		if Signals.current_scene != "bedroom":
			get_tree().change_scene_to_file("res://scenes/Bedroom.tscn")
	else:
		print("Game has ended!")
