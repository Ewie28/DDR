extends Node2D

signal IncrementScore(incr: int)

signal CreateFallingKey(button_name: String)
signal KeyListnerPress(button_name: String, array_num: int)

# signals for the rhythm game system
signal StartRhythmGame(level_id: String)
signal EndRhythmGame(success: bool)
signal RhythmGameCompleted(level_id: String)

# Scene management
var current_scene = "outside" #eg. outside, ddr, levels 
var transition_scene = false

#exit position
var player_exit_outside_pos_x = 0
var player_exit_outside_pos_y = 0

#starting position
var player_start_outside_pos_x = 0
var player_start_outside_pos_y = 0

func _ready():
	print("Signals script initialized")
	# Connect to our own signals for debugging
	StartRhythmGame.connect(func(level_id): print("StartRhythmGame signal emitted for: " + level_id))
	CreateFallingKey.connect(func(button): print("CreateFallingKey signal emitted for: " + button))
	EndRhythmGame.connect(func(success): print("EndRhythmGame signal emitted with success: " + str(success)))

func finish_change_scene():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "outside":
			current_scene = "bedroom"
		else:
			current_scene = "outside"
			#when adding more scenes, add them here eg ddr
