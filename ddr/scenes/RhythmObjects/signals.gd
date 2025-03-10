extends Node2D
var rhythm_level_id = "default"

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
