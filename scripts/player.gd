extends CharacterBody3D

@export var rhythm_manager: RhythmManager
@export var speed = 18.0
@export var slide_speed = 22.5
@export var jump_velocity = 6.0
@export var gravity = -9.8

@onready var animated_sprite_3d: AnimatedSprite3D = $FlipParent/AnimatedSprite3D
@onready var flip_parent: Node3D = $FlipParent


var was_on_floor_last_process: bool

var idle_time: float

var facing_right: bool = true

func _ready() -> void:
	was_on_floor_last_process = true
	animated_sprite_3d.animation_finished.connect(on_anim_finished)
	
func on_anim_finished() -> void:
	# Attack finish
	if is_in_attack_animation():
		print("back to idle")
		play_animation_synced("idle", 2)
		
	# run_start into run
	if animated_sprite_3d.animation == "run_start":
		play_animation_synced("run", 1)
	
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
			animated_sprite_3d.frame = 0
		elif Input.is_action_pressed("ui_down"):
			animated_sprite_3d.play("punch_low")
			animated_sprite_3d.frame = 0
			velocity.x = (1 if facing_right else -1) * slide_speed
		else:
			animated_sprite_3d.play("punch_middle")
			animated_sprite_3d.frame = 0
		
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
			flip_parent.scale.x = -1.0
			facing_right = false
		elif Input.get_axis("ui_left", "ui_right") > 0.0:
			flip_parent.scale.x = 1.0
			facing_right = true
	
		if velocity.x != 0:
			idle_time = 0
			if (animated_sprite_3d.animation != "run_start" and animated_sprite_3d.animation != "run"):
				animated_sprite_3d.play("run_start")
		elif not is_in_attack_animation():
			idle_time += delta
			if idle_time > 5.0:
				play_animation_synced("intro", 4)
			else:
				play_animation_synced("idle", 2)
				
	if animated_sprite_3d.animation == "intro":
		animated_sprite_3d.position.y = 0.435
	else:
		animated_sprite_3d.position.y = 0.535
			
		
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
		return animated_sprite_3d.frame > 3
	elif animated_sprite_3d.animation == "punch_middle":
		return animated_sprite_3d.frame > 6
	elif animated_sprite_3d.animation == "punch_high":
		return animated_sprite_3d.frame > 6
		
	return true

func play_animation_synced(anim: StringName, anim_beat_length: float = 1.0, beat_offset: float = 0.0) -> void:
	animated_sprite_3d.animation = anim
	var frame_count = animated_sprite_3d.sprite_frames.get_frame_count(anim)
	var anim_time = anim_beat_length / rhythm_manager.beats_per_second
	var anim_fps = frame_count / anim_time
	
	var offset_beat = rhythm_manager.current_beat + beat_offset
	var anim_progress = (offset_beat / anim_beat_length) - floor(offset_beat / anim_beat_length)
	var frame = floor(anim_progress * frame_count)
	var frame_progress = (anim_progress * frame_count) - floor(anim_progress * frame_count)
	animated_sprite_3d.play(anim)
	animated_sprite_3d.sprite_frames.set_animation_speed(anim, anim_fps)
	animated_sprite_3d.set_frame_and_progress(frame, frame_progress)
	#print("playing ", anim, " at fps=", anim_fps, " frame=", frame, " frame_progess=", frame_progress)
	
