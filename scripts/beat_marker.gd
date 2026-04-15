class_name BeatMarker
extends TextureRect

var start_position: Vector2
var target_position: Vector2
var move_time: float


var current_time: float = 0


func animate_move(start_pos: Vector2, target_pos: Vector2, time: float):
	#center fix
	start_pos -= size/2
	target_pos -= size/2
	
	global_position = start_pos
	start_position = start_pos
	target_position = target_pos
	move_time = time
	modulate = Color.TRANSPARENT
	
func _process(_delta: float) -> void:
	current_time += _delta
	
	if current_time > move_time:
		queue_free()
		return
	
	global_position = lerp(start_position, target_position, current_time/move_time)
	modulate = lerp(Color.TRANSPARENT, Color.WHITE, current_time/move_time)
