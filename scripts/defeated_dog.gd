class_name DefeatedDog
extends Node3D

@export var time_until_despawn: float = 2.0

@onready var sprite_3d: Sprite3D = $Sprite3D

var velocity: Vector3

func spawn() -> void:
	sprite_3d.modulate = Color.WHITE
	var tween = create_tween()
	tween.tween_property(sprite_3d, "modulate", 0, time_until_despawn)
	await get_tree().create_timer(time_until_despawn).timeout
	queue_free()
	
func _process(delta: float) -> void:
	velocity.y += 10.0 * delta
	global_position += velocity * delta
