extends CharacterBody3D

@export var speed = 18.0
@export var slide_speed = 22.5
@export var jump_velocity = 6.0
@export var gravity = -9.8

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D

var was_on_floor_last_process: bool

var idle_time: float

func _ready() -> void:
	was_on_floor_last_process = true
	animated_sprite_3d.animation_finished.connect(on_anim_finished)
	
func on_anim_finished() -> void:
	# Attack finish
	if is_in_attack_animation():
		print("back to idle")
		animated_sprite_3d.play("idle")
		
	# run_start into run
	if animated_sprite_3d.animation == "run_start":
		animated_sprite_3d.play("run")
	
func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		idle_time = 0
		velocity.y += gravity * delta
		if was_on_floor_last_process:
			pass
			# Once HL finishes the jump anim
			#animated_sprite_3d.play("fall") 
		
	# Attack
	if Input.is_action_just_pressed("punch") and can_act():
		##Half horizontal velocity if in air
		#if not is_on_floor():
			#velocity.x /= 2
		
		idle_time = 0
		print("punched")
		if Input.is_action_pressed("ui_up"):
			animated_sprite_3d.play("punch_high")
		elif Input.is_action_pressed("ui_down"):
			animated_sprite_3d.play("punch_low")
			velocity.x = (-1 if animated_sprite_3d.flip_h else 1) * slide_speed
		else:
			animated_sprite_3d.play("punch_middle")
		
	# Stop player form sliding if they are attacking and on the floor. (Not for low attack which is a slide)
	if animated_sprite_3d.animation in ["punch_middle", "punch_high"] and is_on_floor():
		velocity.x = 0
		
	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor() and can_act():
		idle_time = 0
		velocity.y = jump_velocity
		# Once HL finishes the jump anim
		#animated_sprite_3d.play("jump") 
		
		
	# Horizontal movement
	if can_act():
		var direction = Input.get_axis("ui_left", "ui_right")
		velocity.x = direction * speed
	
		if Input.get_axis("ui_left", "ui_right") < 0.0:
			animated_sprite_3d.flip_h = true
		elif Input.get_axis("ui_left", "ui_right") > 0.0:
			animated_sprite_3d.flip_h = false
	
		if velocity.x != 0:
			idle_time = 0
			if (animated_sprite_3d.animation != "run_start" and animated_sprite_3d.animation != "run"):
				animated_sprite_3d.play("run_start")
		elif not is_in_attack_animation():
			idle_time += delta
			if idle_time > 5.0:
				animated_sprite_3d.play("intro")
			else:
				animated_sprite_3d.play("idle")
			
		
	#if is_on_wall() and not is_on_floor():
		#var normal = get_wall_normal()
		#velocity.x = -normal.x * 0.1
	
	was_on_floor_last_process = is_on_floor()
	move_and_slide()
	
func is_in_attack_animation() -> bool:
	return (animated_sprite_3d.animation == "punch_low"
	or animated_sprite_3d.animation == "punch_middle"
	or animated_sprite_3d.animation == "punch_high")
	
func is_hurt() -> bool:
	return animated_sprite_3d.animation == "hurt"
	
## Can jump, move or attack
func can_act() -> bool:
	if is_hurt(): 
		return false
		
	# Attack cancel frames
	if animated_sprite_3d.animation == "punch_low":
		return animated_sprite_3d.frame > 4
	elif animated_sprite_3d.animation == "punch_middle":
		return animated_sprite_3d.frame > 7
	elif animated_sprite_3d.animation == "punch_high":
		return animated_sprite_3d.frame > 7
		
	return true
