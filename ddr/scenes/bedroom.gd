extends Control

#to go to outside
func on_start_pressed() -> void:
	Signals.transition_scene = true
	change_scene()
	
func change_scene():
	if Signals.transition_scene == true:
		if Signals.current_scene == "bedroom":
			#transition happens here, add the cutscene here for when transitioning from outside to bedroom if any
			Signals.finish_change_scene() #used so bedroom can communicate with outside scene?
			get_tree().change_scene_to_file("res://scenes/outside.tscn") #this is how to change to this file
