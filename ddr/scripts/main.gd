extends Node

var current_scene = "outside" #eg. outside, ddr, levels 
var transition_scene = false

#exit position
var player_exit_outside_pos_x = 0
var player_exit_outside_pos_y = 0

#starting position
var player_start_outside_pos_x = 0
var player_start_outside_pos_y = 0

func finish_change_scene():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "outside":
			current_scene = "bedroom"
		else:
			current_scene = "outside"
			#when adding more scenes, add them here eg ddr
