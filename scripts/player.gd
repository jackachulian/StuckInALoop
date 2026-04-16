class_name Player
extends CharacterBody3D

# ==== PLAYER

@export var rhythm_manager: RhythmManager
@export var hurtbox: Hurtbox
@export var health: int = 3
@export var hit_invincibility_time: float = 1.0
@export var speed = 18.0
@export var slide_speed = 22.5
@export var jump_velocity = 6.0
@export var gravity = -9.8
@export var coyote_time := 0.1
@export var jump_buffer_time := 0.1
@export var scene_transition: SceneTransition

@onready var animated_sprite_3d: AnimatedSprite3D = $FlipParent/AnimatedSprite3D
@onready var flip_parent: Node3D = $FlipParent

@onready var punch_middle_hitbox: Hitbox = $FlipParent/PunchMiddleHitbox
@onready var punch_low_hitbox: Hitbox = $FlipParent/PunchLowHitbox
@onready var punch_high_hitbox: Hitbox = $FlipParent/PunchHighHitbox
@onready var effectiveness_label: RhythmEffectivenessText = $EffectivenessLabel
@onready var rhythm_camera: RhythmCamera = $Camera3D
@onready var hit_sound_player: AudioStreamPlayer3D = $Camera3D/HitSoundPlayer

signal health_changed

# Miss, Okay, Good, Great, Perfect

var was_on_floor_last_process: bool
var idle_time: float
var facing_right: bool = true
var coyote_timer := 0.0
var jump_buffer_timer := 0.0
var hit_invincibility_timer := 0.0
var hit_effectiveness: RhythmManager.HitEffectiveness # of last attack

func _ready() -> void:
	was_on_floor_last_process = true
	animated_sprite_3d.animation_finished.connect(_on_anim_finished)
	animated_sprite_3d.frame_changed.connect(_on_frame_changed)
	
func _on_frame_changed():
	var hit_direction := 1 if facing_right else -1
	
	var perfect: bool = hit_effectiveness == RhythmManager.HitEffectiveness.Perfect
	var knockback_mult: float = 1.5 if hit_effectiveness == RhythmManager.HitEffectiveness.Perfect else 1.0
	
	if animated_sprite_3d.animation == "punch_middle" and animated_sprite_3d.frame == 1:
		punch_middle_hitbox.hit(Vector3(hit_direction*8.0, 5.0, 0.0)*knockback_mult, 2 if perfect else 1)
	elif animated_sprite_3d.animation == "punch_high" and animated_sprite_3d.frame == 1:
		punch_high_hitbox.hit(Vector3(hit_direction*12.5, 22.5, 0.0)*knockback_mult, 1)
	elif animated_sprite_3d.animation == "punch_low" and animated_sprite_3d.frame == 1:
		punch_low_hitbox.hit(Vector3(hit_direction*17.5, 7.5, 0.0)*knockback_mult, 1, 999)
	
func _on_anim_finished() -> void:
	# Attack finish
	if is_in_attack_animation() or is_hurt():
		play_animation_synced("idle", 2)
		
	# run_start into run
	if animated_sprite_3d.animation == "run_start":
		play_animation_synced("run", 1)
	
func _physics_process(delta: float) -> void:
	if (hit_invincibility_timer > 0):
		hit_invincibility_timer -= delta
		if hit_invincibility_timer <= 0:
			print("invincibility over")
			hurtbox.monitorable = true
			hurtbox.monitoring = true
			hurtbox.collision_shape_3d.disabled = false
	
	# Gravity
	if not is_on_floor():
		idle_time = 0
		velocity.y += gravity * delta
		if was_on_floor_last_process:
			pass
			# Once HL finishes the jump anim
			#animated_sprite_3d.play("fall") 
		
	if health <= 0:
		if is_on_floor():
			velocity.x = 0
		move_and_slide()
		return
		
	# Attack
	if Input.is_action_just_pressed("punch"):
		# Consume the beat even if currently in an action
		hit_effectiveness = rhythm_manager.consume_beat()
		idle_time = 0
		if can_act():
			# Then if not in an action, show the label and transition if successful
			effectiveness_label.show_effectiveness(hit_effectiveness)
			#rhythm_camera.rhythm_hit_camera_effect(hit_effectiveness)
			if hit_effectiveness != RhythmManager.HitEffectiveness.Miss:
				hit_sound_player.play()
				rhythm_camera.rhythm_hit_camera_effect(hit_effectiveness, 0.33)
				if Input.is_action_pressed("ui_up"):
					animated_sprite_3d.play("punch_high")
					animated_sprite_3d.frame = 0
				elif Input.is_action_pressed("ui_down"):
					animated_sprite_3d.play("punch_low")
					animated_sprite_3d.frame = 0
					var dash_strength: float = [0.0, 0.55, 0.75, 0.9, 1.00][hit_effectiveness]
					velocity.x = (1 if facing_right else -1) * slide_speed * dash_strength
					velocity.y -= 15.0 * dash_strength
				else:
					animated_sprite_3d.play("punch_middle")
					animated_sprite_3d.frame = 0
			
	# Stop player form sliding if they are attacking and on the floor. (Not for low attack which is a slide)
	if animated_sprite_3d.animation in ["punch_middle", "punch_high"] and is_on_floor():
		velocity.x = 0
		
	# Coyote time
	if is_on_floor():
		coyote_timer = coyote_time
	else:
		coyote_timer -= delta
		
	# Buffer a jump
	if Input.is_action_just_pressed("jump"):
		jump_buffer_timer = jump_buffer_time
	else:
		jump_buffer_timer -= delta
		
	# Jump
	if jump_buffer_timer > 0 and coyote_timer > 0 and can_act():
		idle_time = 0
		velocity.y = jump_velocity
		jump_buffer_timer = 0
		coyote_timer = 0
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
		animated_sprite_3d.position.y = 0.555
			
		
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
	
func take_damage(damage: int):
	print(name, " took ", damage, " damage")
	health -= damage
	health_changed.emit()
	if (health <= 0):
		animated_sprite_3d.animation = "hurt"
		await animated_sprite_3d.animation_finished
		hide()
		scene_transition.transition_to_scene("res://scenes/level.tscn")
	else:
		hit_invincibility_timer = hit_invincibility_time
		animated_sprite_3d.animation = "hurt"
		print("invincibility started")
		hurtbox.monitorable = false
		hurtbox.monitoring = false
		hurtbox.collision_shape_3d.disabled = true
	
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
	
