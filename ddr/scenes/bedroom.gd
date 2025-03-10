extends Control

func _ready():
	check_next_day()
	
func check_next_day():
	if Signals.missions_attempted >= Signals.MAX_MISSIONS:
		Signals.next_day()
		print("next day")

#to go to outside
func on_start_pressed() -> void:
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
