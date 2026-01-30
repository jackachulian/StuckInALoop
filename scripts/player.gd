extends CharacterBody3D

# =======================
# CONFIG
# =======================

@export var beat_manager: BeatManager

@export var move_speed := 6.0
@export var jump_velocity := 8.0
@export var gravity := 24.0

@export var dash_speed := 18.0
@export var dash_time := 0.15

@export var punch_time := 0.2
@export var dive_speed := 22.0

@export var slide_speed := 14.0
@export var slide_time := 0.25

@export var perfect_window := 0.06
@export var good_window := 0.11
@export var buffer_time := 0.15

# =======================
# STATE
# =======================

var facing_dir := Vector3.FORWARD
var beat_available := false
var action_lock := false
var no_gravity_timer := 0.0

var input_buffer: Array[BufferedInput] = []
var last_beat_time := 0.0

# =======================
# READY
# =======================

func _ready():
	beat_manager.beat.connect(_on_beat)


# =======================
# PROCESS
# =======================

func _process(_delta: float):
	if Input.is_action_just_pressed("jump"):
		buffer_input("jump")

	if Input.is_action_just_pressed("punch"):
		buffer_input("punch")

	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		buffer_input("dash")

	if Input.is_action_pressed("ui_down"):
		buffer_input("slide")

	cleanup_buffer()


# =======================
# INPUT BUFFER MANAGEMENT
# =======================

func buffer_input(action: String):
	var entry = BufferedInput.new()
	entry.action = action
	entry.direction = get_action_direction()
	entry.time = beat_manager.song_time
	input_buffer.append(entry)

func cleanup_buffer():
	var now = beat_manager.song_time
	input_buffer = input_buffer.filter(func(i):
		return now - i.time <= buffer_time
	)


# =======================
# BEAT HANDLING
# =======================

enum BeatRating { PERFECT, EARLY, LATE, MISS }

func _on_beat(beat_time: float):
	last_beat_time = beat_time

	var best_input: BufferedInput = null
	var best_diff := INF

	for input in input_buffer:
		var diff = abs(input.time - beat_time)
		if diff < best_diff:
			best_diff = diff
			best_input = input

	if best_input:
		var rating = rate_input(best_input.time, beat_time)
		execute_buffered_action(best_input, rating)
		input_buffer.clear()

func rate_input(input_time: float, beat_time: float) -> BeatRating:
	var delta = input_time - beat_time

	if abs(delta) <= perfect_window:
		return BeatRating.PERFECT
	elif abs(delta) <= good_window:
		return BeatRating.EARLY if delta < 0 else BeatRating.LATE
	else:
		return BeatRating.MISS


# =======================
# INPUT HELPERS
# =======================

func get_input_direction() -> Vector3:
	var dir := Vector3.ZERO
	dir.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	dir.z = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	return dir.normalized()

func get_action_direction() -> Vector3:
	var dir = get_input_direction()
	if dir == Vector3.ZERO:
		return facing_dir
	return dir

# =======================
# PHYSICS
# =======================

func _physics_process(delta):
	# Gravity
	if no_gravity_timer > 0:
		no_gravity_timer -= delta
	else:
		if not is_on_floor():
			velocity.y -= gravity * delta

	# Ground movement (free between beats)
	if not action_lock:
		var dir = get_input_direction()
		if dir != Vector3.ZERO:
			facing_dir = dir
			velocity.x = dir.x * move_speed
			velocity.z = dir.z * move_speed
		else:
			velocity.x = move_toward(velocity.x, 0, move_speed)
			velocity.z = move_toward(velocity.z, 0, move_speed)

	# Beat actions
	#if beat_available and not action_lock:
		#handle_beat_actions()

	move_and_slide()

# =======================
# BEAT ACTIONS
# =======================

func execute_buffered_action(input: BufferedInput, rating: BeatRating):
	match input.action:
		"dash":
			start_dash(input.direction, rating)
		"punch":
			start_punch(input.direction, rating)
		"jump":
			start_jump(input.direction)
		"slide":
			start_slide(input.direction)


# =======================
# ACTIONS
# =======================

func start_dash(dir: Vector3, rating: BeatRating):
	var mult := 1.0
	match rating:
		BeatRating.PERFECT:
			mult = 1.25
		BeatRating.EARLY, BeatRating.LATE:
			mult = 0.9

	action_lock = true
	no_gravity_timer = dash_time
	velocity = dir * dash_speed * mult

	await get_tree().create_timer(dash_time).timeout
	action_lock = false

func start_punch(dir: Vector3, _rating: BeatRating):
	action_lock = true
	no_gravity_timer = punch_time

	if not is_on_floor() and Input.is_action_pressed("ui_down"):
		velocity = Vector3.DOWN * dive_speed
	else:
		velocity = dir * (dash_speed * 0.8)

	# TODO: spawn hitbox here

	await get_tree().create_timer(punch_time).timeout
	action_lock = false

func start_jump(dir: Vector3):
	velocity.y = jump_velocity
	velocity.x = dir.x * move_speed
	velocity.z = dir.z * move_speed

func start_slide(dir: Vector3):
	action_lock = true
	velocity = dir * slide_speed
	await get_tree().create_timer(slide_time).timeout
	action_lock = false
