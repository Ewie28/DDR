extends Area2D


func _on_body_entered(body: Node2D) -> void:
	Signals.transition_scene = true
	change_scene()
	
func change_scene(): #all sprites are linked to this method/script
	if Signals.transition_scene == true:
			Signals.finish_change_scene() #used so bedroom can communicate with outside scene?
			get_tree().change_scene_to_file("res://scenes/Rhythms/BaseRhythm.tscn") #change this link for correct mission and level
			
			
#no need exit because they will exit from rythm
