extends Node2D

func _process(delta: float) -> void:
	change_scene()

func _on_bedroom_transition_body_entered(body):
	if body.has_method("player"):
		Signals.desired_scene = "bedroom"
		Signals.transition_scene = true
		change_scene()


func change_scene():
	if Signals.transition_scene == true:
		#if Signals.current_scene == "outside":
			if Signals.desired_scene == "bedroom":
				#transition happens here, add the cutscene here for when transitioning from outside to bedroom if any
				Signals.finish_change_scene() #used so bedroom can communicate with outside scene?
				get_tree().change_scene_to_file("res://scenes/Bedroom.tscn") #this is how to change to this file
			elif Signals.desired_scene == "rhythm":
				Signals.finish_change_scene()
				#no scene change bc we did it a different way


				
		
