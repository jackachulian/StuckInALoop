extends Sprite3D


@export var camera: Camera3D
@export var scale_factor: float = 0.2

var start_pos
var camera_start_pos
@export var create_children: bool = false

func _ready() -> void:
	if not create_children: return
	
	start_pos = global_position
	camera_start_pos = camera.global_position
	
	for i in range(-4, 4):
		if i == 0: continue
		
		var size := get_sprite3d_world_size()
		create_children = false
		var new: Sprite3D = duplicate()
		get_parent().add_child.call_deferred(new)
		var child_pos = global_position
		child_pos.x += size.x * i
		new.call_deferred("initialize_child", child_pos)

func initialize_child(global_pos: Vector3) -> void:
	global_position = global_pos
	start_pos = global_position
	camera_start_pos = camera.global_position

func get_sprite3d_world_size() -> Vector2:
	var tex_size = texture.get_size()

	# Convert to world units using pixel_size and scale
	var world_width = tex_size.x * pixel_size * scale.x
	var world_height = tex_size.y * pixel_size * scale.y

	return Vector2(world_width, world_height)


func _process(_delta: float) -> void:
	global_position = start_pos + (camera.global_position - camera_start_pos) * scale_factor
	global_position.z = start_pos.z
