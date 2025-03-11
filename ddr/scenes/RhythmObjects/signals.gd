extends Node2D
var rhythm_level_id = "default"
var HintUI = preload("res://scenes/hintbox.tscn")
var hint_ui_instance = null

#for missions 
var current_day = 1
var missions_attempted = 0
const MAX_MISSIONS = 3

var missions_failed = 0
const MAX_FAILURES = 5



signal DayAdvanced

signal IncrementScore(incr: int)

signal CreateFallingKey(button_name: String)
signal KeyListnerPress(button_name: String, array_num: int)

# signals for the rhythm game system
signal StartRhythmGame(level_id: String)
signal EndRhythmGame(success: bool)
signal RhythmGameCompleted(level_id: String)

signal RhythmGameResult(score: int, success: bool)

# Scene management
var current_scene = "bedroom" #eg. outside, ddr, levels 
var desired_scene = "bedroom"
var transition_scene = false

#exit position
var player_exit_outside_pos_x = 0
var player_exit_outside_pos_y = 0

#starting position
var player_start_outside_pos_x = 0
var player_start_outside_pos_y = 0

var completed_missions = {}  # Dictionary to track completed missions by ID

# check if a mission is completed
# For signals.gd - add these debug statements
func is_mission_completed(mission_id: String) -> bool:
	var is_completed = mission_id in completed_missions and completed_missions[mission_id] == true
	print("Checking if mission " + mission_id + " is completed: " + str(is_completed))
	print("Current completed_missions: " + str(completed_missions))
	return is_completed

func mark_mission_completed(mission_id: String):
	completed_missions[mission_id] = true
	print("Mission marked as completed: " + mission_id)
	print("Updated completed_missions: " + str(completed_missions))

func _ready():
	print("Signals script initialised")
	# Connect to our own signals for debugging
	StartRhythmGame.connect(func(level_id): print("StartRhythmGame signal emitted for: " + level_id))
	CreateFallingKey.connect(func(button): pass)
	EndRhythmGame.connect(func(success): print("EndRhythmGame signal emitted with success: " + str(success)))
	
	# Create and add the hint UI instance
	hint_ui_instance = HintUI.instantiate()
	add_child(hint_ui_instance)

func finish_change_scene():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "outside":
			if desired_scene == "bedroom":
				current_scene = "bedroom"
			elif desired_scene == "rhythm":
				current_scene = "rhythm"
		elif current_scene == "bedroom":
			current_scene == "outside"
			#when adding more scenes, add them here eg ddr
			
func attempt_mission():
	if missions_attempted < MAX_MISSIONS:
		missions_attempted += 1
		print("Mission", missions_attempted, "completed for Day", current_day)

	if missions_attempted == MAX_MISSIONS:
		next_day()
		
func next_day():
	current_day += 1
	missions_attempted = 0
	print("Advancing to Day", current_day)
	#DayAdvanced.emit()  # Notify scenes to update interactables
	
func increment_failures():
	missions_failed = min(missions_failed + 1, MAX_FAILURES)
	print("Rhythm failures increased to: " + str(missions_failed))
	var timer = get_tree().create_timer(6.0)
	timer.timeout.connect(show_fail_hint)
	
func show_hint(text_message: String) -> void:
	if hint_ui_instance:
		hint_ui_instance.show_hint(text_message)
		print("HINT shown")

func show_fail_hint() -> void:
	# Show the hint after the 6-second delay
	if missions_failed == MAX_FAILURES:
		show_hint("I only have the plant left... let's go home")
		return
	if Signals.missions_attempted == 0:
		return
	if missions_failed == 1:
		show_hint("Gotta sell the bed to pay the bills... :(")
	elif missions_failed == 2:
		show_hint("The carpet wasn't doing much anyway...")
	elif missions_failed == 3:
		show_hint("I'll put the fridge on facebook marketplace...")
	elif missions_failed == 4:
		show_hint("That's alright, I'll sit on the floor...")
