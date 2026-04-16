class_name Hurtbox
extends Area3D

@export var entity: CharacterBody3D
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D

@export var tags: Array[String]

func take_damage(damage: int):
	entity.take_damage(damage)

func take_knockback(knockback: Vector3):
	entity.velocity = knockback
	
