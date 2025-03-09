extends CharacterBody2D

const speed = 100
var current_dir = "none"

#required to check if this is the player
func player():
	pass

func _physics_process(delta):
	player_movement(delta)
	current_camera()

func player_movement(delta):
	if Signals.desired_scene == "rhythm":
		pass
	else:
		if Input.is_action_pressed("ui_right"):
			current_dir = "right"
			play_anim(1)
			velocity.x = speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_left"):
			current_dir = "left"
			play_anim(1)
			velocity.x = -speed
			velocity.y = 0
		elif Input.is_action_pressed("ui_down"):
			current_dir = "down"
			play_anim(1)
			velocity.y = speed
			velocity.x = 0
		elif Input.is_action_pressed("ui_up"):
			current_dir = "up"
			play_anim(1)
			velocity.y = -speed
			velocity.x = 0
		else:
			play_anim(0)
			velocity.x = 0
			velocity.y = 0
			
		move_and_slide()

func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	
	if dir == "right":
		anim.flip_h = false
		if movement == 1:
			anim.play("right_walk")
		elif movement == 0:
			anim.play("right_idle")
			
	
	if dir == "left":
		anim.flip_h = true
		if movement == 1:
			anim.play("right_walk")
		elif movement == 0:
			anim.play("right_idle")
	
	if dir == "down":
		if movement == 1:
			anim.play("right_walk")
		elif movement == 0:
			anim.play("right_idle")

	if dir == "up":
		if movement == 1:
			anim.play("right_walk")
		elif movement == 0:
			anim.play("right_idle")
			
			
func current_camera():
	if Signals.desired_scene =="outside":
		$Outside_camera.enabled = true
		$Bedroom_camera.enabled = false
	elif Signals.desired_scene =="bedroom":
		$Outside_camera.enabled = false
		$Bedroom_camera.enabled = true
	elif Signals.desired_scene == "rhythm":
		$Outside_camera.enabled = false
		$Bedroom_camera.enabled = false
