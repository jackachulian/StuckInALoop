class_name Dog
extends CharacterBody3D

# ==== DOG

@export var rhythm_manager: RhythmManager
@export var player_node: Node3D
@export var health: int = 5
@export var speed = 7.5
@export var attack_slide_speed = 10.0
@export var attack_distance = 5.0
@export var jump_velocity = 20
@export var gravity = -80
@export var hurt_attack_delay = 0.25

@onready var animated_sprite_3d: AnimatedSprite3D = $FlipParent/AnimatedSprite3D
@onready var flip_parent: Node3D = $FlipParent

var facing_right: bool = true
var hurt_timer := 0.0

func _ready() -> void:
	animated_sprite_3d.animation_finished.connect(_on_anim_finished)
	animated_sprite_3d.frame_changed.connect(_on_frame_changed)
	play_animation_synced("walk", 2)
	hurt_timer = hurt_attack_delay
	
func _on_beat():
	if animated_sprite_3d.animation == "attack_prepare":
		animated_sprite_3d.animation = "attack"
		velocity.x = (1 if facing_right else -1) * attack_slide_speed
		
	# prepare to attack if player nearby
	elif animated_sprite_3d.animation == "walk":
		var distance_from_player = player_node.position.distance_to(position)
		if (distance_from_player <= attack_distance):
			animated_sprite_3d.play("attack_prepare")
			animated_sprite_3d.frame = 0
	
func _on_frame_changed():
	animated_sprite_3d.material_override.set_shader_parameter("tex", 
	animated_sprite_3d.sprite_frames.get_frame_texture(animated_sprite_3d.animation, animated_sprite_3d.frame))

func _on_anim_finished() -> void:
	# Attack finish
	if animated_sprite_3d.animation == "attack":
		play_animation_synced("walk", 2)
	
func _physics_process(delta: float) -> void:
	hurt_timer += delta
	
	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta
		
	# Jump on hit wall
	if is_on_wall():
		velocity.y = jump_velocity
		
	# Horizontal movement
	if can_move():
		var direction: float = 0
	
		if player_node.position.x < position.x - 0.05:
			direction = -1
			flip_parent.scale.x = -1.0
			facing_right = false
		elif player_node.position.x > position.x + 0.05:
			direction = 1
			flip_parent.scale.x = 1.0
			facing_right = true		
			
		velocity.x = direction * speed
		
	move_and_slide()
	
func can_move():
	return hurt_timer > hurt_attack_delay and not is_in_attack_animation() and is_on_floor()
	
func is_in_attack_animation() -> bool:
	return animated_sprite_3d.animation in ["attack_prepare", "attack"]

func take_damage(damage: int):
	print(name, " took ", damage, " damage")
	health -= damage
	hurt_timer = 0.0
	if (health <= 0):
		queue_free()
	else:
		flash_damage()

func flash_damage():
	animated_sprite_3d.material_override.set_shader_parameter("flash_strength", 1.0)
	await get_tree().create_timer(0.1).timeout
	animated_sprite_3d.material_override.set_shader_parameter("flash_strength", 0.0)

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
	
