extends Node2D
# Preload the UI scene
var HintUI = preload("res://scenes/hintbox.tscn")
var hint_ui_instance = null

func _ready():
	Signals.DayAdvanced.connect(update_interactable_nodes)  # Connect signal ONCE
	update_interactable_nodes()  # Update interactable nodes when the scene loads
	MusicManager.play_outside_music()
	
	# Create and add the hint UI instance
	hint_ui_instance = HintUI.instantiate()
	add_child(hint_ui_instance)
	
	show_hint("Got bills to pay... there's " + str(3 - Signals.missions_attempted) + " odd jobs left to do today.")

func update_interactable_nodes():
	for node in get_tree().get_nodes_in_group("interactables"):
		if node.has_method("update_active_state"):
			node.update_active_state()
			
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
				
# Function to show a hint from the outside scene
func show_hint(text_message: String) -> void:
	if hint_ui_instance:
		hint_ui_instance.show_hint(text_message)
		print("HINT shown")
