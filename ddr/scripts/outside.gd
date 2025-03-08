extends Node2D

func _process(delta: float) -> void:
	change_scene()

func _on_bedroom_transition_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		Main.transition_scene = true


func _on_bedroom_transition_body_exited(body: Node2D) -> void:
	if body.has_method("player"): 
		Main.transition_scene = false

func change_scene():
	if Main.transition_scene == true:
		if Main.current_scene == "outside":
			#transition happens here, add the cutscene here for when transitioning from outside to bedroom if any
				get_tree().change_scene_to_file("res://scenes/Bedroom.tscn") #this is how to change to this file
				Main.finish_change_scene() #used so bedroom can communicate with outside scene?
		
