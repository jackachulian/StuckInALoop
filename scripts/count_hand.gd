class_name CountHand
extends CharacterBody3D

@export var count: CountPWright

var initial_offset: Vector3

func _ready() -> void:
	initial_offset = global_position - count.global_position

func _process(delta: float) -> void:
	var target_position = count.global_position + initial_offset
	var offset = global_position - target_position
	global_position = global_position.move_toward(target_position, offset.length() * 2.0 * delta)
