extends Sprite3D

@export var camera: Camera3D
@export var scale_factor: float = 0.2

var start_pos
var camera_start_pos

func _ready() -> void:
	start_pos = global_position
	camera_start_pos = camera.global_position

func _process(delta: float) -> void:
	global_position = start_pos + (camera.global_position - camera_start_pos) * scale_factor
