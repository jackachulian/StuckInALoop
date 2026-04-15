extends Node3D

@export var rotation_speed: float = 3.0
@export var max_rotation_angle: float = 15.0 # degrees

@export var look_point_movement_scale: Vector2 = Vector2(0.05, 0.05)
@export var look_speed: float = 10.0  # Higher = faster movement

var current_look_point: Vector3

func _ready() -> void:
	var camera = get_viewport().get_camera_3d()
	current_look_point = camera.global_position

func _process(delta: float):
	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_normalized_position = mouse_pos / get_viewport().get_visible_rect().size - (Vector2.ONE / 2)
	var camera = get_viewport().get_camera_3d()
	if camera == null:
		return

	var target_look_point = camera.global_position
	target_look_point.x += mouse_normalized_position.x * look_point_movement_scale.x
	target_look_point.y -= mouse_normalized_position.y * look_point_movement_scale.y
	
	current_look_point = current_look_point.lerp(target_look_point, 1.0 - exp(-look_speed * delta))

	look_at(current_look_point, Vector3.UP)
