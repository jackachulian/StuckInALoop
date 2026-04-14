extends CharacterBody3D

@export var speed = 5.0
@export var jump_velocity = 6.0
@export var gravity = -9.8

@onready var animated_sprite_3d: AnimatedSprite3D = $AnimatedSprite3D

var was_on_floor_last_process: bool

var idle_time: float

func _ready() -> void:
	was_on_floor_last_process = true
	
func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		idle_time = 0
		velocity.y += gravity * delta
		if was_on_floor_last_process:
			pass
			# Once HL finishes the jump anim
			#animated_sprite_3d.play("fall") 
		
	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and can_act():
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
			if animated_sprite_3d.animation == "run_start" and animated_sprite_3d.animation_finished:
				animated_sprite_3d.play("run")
			elif (animated_sprite_3d.animation != "run_start" and animated_sprite_3d.animation != "run"):
				animated_sprite_3d.play("run_start")
		elif can_act():
			idle_time += delta
			if idle_time > 8.0:
				animated_sprite_3d.play("intro")
			else:
				animated_sprite_3d.play("idle")
		
	#if is_on_wall() and not is_on_floor():
		#var normal = get_wall_normal()
		#velocity.x = -normal.x * 0.1
	
	was_on_floor_last_process = is_on_floor()
	move_and_slide()
	
func is_attacking() -> bool:
	return (animated_sprite_3d.animation == "punch_low"
	or animated_sprite_3d.animation == "punch_medium"
	or animated_sprite_3d.animation == "punch_high")
	
func is_hurt() -> bool:
	return animated_sprite_3d.animation == "hurt"
	
## Can jump, move or attack
func can_act() -> bool:
	return (not is_attacking() and not is_hurt())
