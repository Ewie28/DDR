extends Area2D

var HintUI = preload("res://scenes/hintbox.tscn")
var hint_ui_instance = null


var level_id = "rhythm1"
# Reference to the BaseRhythm scene (preload it)
@onready var base_rhythm_scene = preload("res://scenes/Rhythms/BaseRhythm.tscn")
var base_rhythm_instance = null
@export var day_active = 1  # The day this mission should be active
@export var mission_id = "mission1" 

func _ready():
	
	# Create and add the hint UI instance
	hint_ui_instance = HintUI.instantiate()
	add_child(hint_ui_instance)
	
	print("Area2D Cat _ready called for mission: " + mission_id)
	Signals.EndRhythmGame.connect(_on_rhythm_game_ended)
	Signals.RhythmGameResult.connect(_on_rhythm_game_result)
	# Add a small delay to ensure Signals is fully ready
	get_tree().create_timer(0.1).timeout.connect(func(): update_active_state())

func update_active_state():
	print("Updating active state for mission: " + mission_id)
	# First check if this mission has already been completed
	if Signals.is_mission_completed(mission_id):
		print("Mission " + mission_id + " already completed, setting inactive")
		set_active(false)
		return
	
	# Check the current day and enable/disable interactability accordingly
	if (Signals.current_day == day_active):
		print("Day matches for mission " + mission_id + ", setting active: true")
		set_active(true)  # Clickable
	else:
		print("Day doesn't match for mission " + mission_id + ", setting active: false")
		set_active(false)  # Greyed out

func set_active(is_active: bool):
	set_deferred("monitoring", is_active)  # Enable/disable collision detection
	set_deferred("input_pickable", is_active)  # Enable/disable interactions
	 # Find the AnimatedSprite2D and modify its appearance
	var sprite = get_parent().get_node("Sprite2D")  # Move up to level_1_cat, then find Sprite2D
	if sprite:
		var texture_path = "res://mission_sprites/level1_cat.png" if is_active else "res://mission_sprites/level1_cat_grey.png"
		sprite.texture = load(texture_path)

func _on_body_entered(body: Node2D) -> void:
	Signals.mark_mission_completed(mission_id)
	print("Starting rhythm level: " + level_id)
	Signals.desired_scene = "rhythm"
	
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
	set_active(false)

func _on_rhythm_game_result(score, success):
	print("Rhythm game completed with score: " + str(score) + " for mission: " + mission_id)
	print("Player " + ("PASSED" if success else "FAILED") + " the level")
	if (!success):
		print("MINUS ONE LIFE")
		Signals.increment_failures()
	

# Show the world again when a rhythm game ends
func _on_rhythm_game_ended(_success):
	#add cutscene here when game completed
	Signals.desired_scene = "outside"
	if _success:
		print("end success")
	else:
		print("game ended not  success")
	# Show the world UI again if needed
	# get_tree().current_scene.visible = true
	Signals.attempt_mission()
	print(str(Signals.missions_attempted) + " missions done on day " + str(Signals.current_day))
	
	
	# Remove the rhythm game instance
	if base_rhythm_instance != null:
		base_rhythm_instance.queue_free()
		base_rhythm_instance = null
	
	if (Signals.missions_failed == Signals.MAX_FAILURES):
		Signals.mark_mission_completed(mission_id)
		set_active(false)
	
	var timer = get_tree().create_timer(3.0)
	timer.timeout.connect(show_fail_hint)
	
func show_hint(text_message: String) -> void:
	if hint_ui_instance:
		hint_ui_instance.show_hint(text_message)
		print("HINT shown")

func show_fail_hint() -> void:
	# Show the hint after the 6-second delay
	if Signals.missions_failed == 5:
		return
	if Signals.missions_attempted == 0:
		show_hint("That's enough for today. Let's go home!")
	else:
		return
