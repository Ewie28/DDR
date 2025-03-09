extends Area2D
	
var level_id = "rhythm9"

# Reference to the BaseRhythm scene (preload it)
@onready var base_rhythm_scene = preload("res://scenes/Rhythms/BaseRhythm.tscn")
var base_rhythm_instance = null


func _on_body_entered(body: Node2D) -> void:
	print("Starting rhythm level: " + level_id)
	
	# Hide any UI that needs to be hidden
	# get_tree().current_scene.visible = false
	
	# Instantiate the BaseRhythm scene if it doesn't exist
	if base_rhythm_instance == null:
		base_rhythm_instance = base_rhythm_scene.instantiate()
		get_tree().get_root().add_child(base_rhythm_instance)
	
	# Wait a frame to ensure the scene is ready
	await get_tree().process_frame
	
	# Start the selected rhythm game
	Signals.StartRhythmGame.emit(level_id)

# Handle the result signal
func _on_rhythm_game_result(score, success):
	print("Rhythm game completed with score: " + str(score))
	print("Player " + ("PASSED" if success else "FAILED") + " the level")

# Show the world again when a rhythm game ends
func _on_rhythm_game_ended(_success):
	if _success:
		print("game end")
	else:
		print("game crashed")
	
	# Show the world UI again if needed
	# get_tree().current_scene.visible = true
	
	# Remove the rhythm game instance
	if base_rhythm_instance != null:
		base_rhythm_instance.queue_free()
		base_rhythm_instance = null
