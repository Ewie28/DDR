extends Sprite2D
@onready var falling_key = preload("res://scenes/RhythmObjects/falling_key.tscn")
@onready var score_text = preload("res://scenes/RhythmObjects/ScorePressText.tscn")
@export var key_name: String = ""

var falling_key_queue = []

var perfect_press_threshold: float = 20
var great_press_threshold: float = 40
var good_press_threshold: float = 75
var ok_press_threshold: float = 140
# otherwise, miss

var perfect_press_score: float = 250
var great_press_score: float = 100
var good_press_score: float = 50
var ok_press_score: float = 20

func _ready():
	Signals.CreateFallingKey.connect(CreateFallingKey)
	
# Called every frame. delta is elapsed time since prev frame
func _process(delta):
	
	if Input.is_action_just_pressed(key_name):
		Signals.KeyListnerPress.emit(key_name, frame)
	
	if falling_key_queue.size() > 0:
		
		# If falling key missed, remove from queue
		if is_instance_valid(falling_key_queue.front()) and falling_key_queue.front().has_passed:
			var missed_key = falling_key_queue.pop_front()
			
			
			# print miss
			var st_inst = score_text.instantiate()
			get_tree().get_root().call_deferred("add_child", st_inst)
			st_inst.setTextInfo("MISS")
			st_inst.global_position = global_position
			missed_key.queue_free()  # Free the missed key

			
		# If key pressed, pop from queue and calculate distance
		if Input.is_action_just_pressed(key_name):
			var key_to_pop = null
			var distance_from_pass = null
			var press_score_text: String = ""
			if falling_key_queue.size() > 0 and is_instance_valid(falling_key_queue.front()):
				key_to_pop = falling_key_queue.pop_front()
				distance_from_pass = abs(key_to_pop.pass_threshold - key_to_pop.global_position.y)
				press_score_text = ""
			
				if distance_from_pass < perfect_press_threshold:
					Signals.IncrementScore.emit(perfect_press_score)
					press_score_text = "PERFECT"
				elif distance_from_pass < great_press_threshold:
					Signals.IncrementScore.emit(great_press_score)
					press_score_text = "GREAT"
				elif distance_from_pass < good_press_threshold:
					press_score_text = "GOOD"
					Signals.IncrementScore.emit(good_press_score)
				elif distance_from_pass < ok_press_threshold:
					press_score_text = "OK"
					Signals.IncrementScore.emit(ok_press_score)
				else:
					press_score_text = "MISS"
					
				key_to_pop.queue_free()
				
				var st_inst = score_text.instantiate()
				get_tree().get_root().call_deferred("add_child", st_inst)
				st_inst.setTextInfo(press_score_text)
				st_inst.global_position = global_position
	
func CreateFallingKey(button_name:String):
	if button_name == key_name:
		var fk_inst = falling_key.instantiate()
		get_tree().get_root().call_deferred("add_child", fk_inst)  
		fk_inst.Setup(position.x, frame + 4)
		
		falling_key_queue.push_back(fk_inst)


func _on_random_spawn_time_timeout() -> void:
	#CreateFallingKey()
	$RandomSpawnTime.wait_time = randf_range(0.4, 3)
	$RandomSpawnTime.start()
