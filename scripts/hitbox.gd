class_name Hitbox
extends Area3D

@export var attacker_entity: CharacterBody3D
@export var damage: int = 1
@export var can_always_hit: bool

# Ensure this only hits once per attack
var can_hit: bool

var current_knockback: Vector3 # Velocity to add to hit target
var current_damage: int
var current_duration: float
var duration_timer := 0.0

func _ready() -> void:
	monitoring = false
	area_entered.connect(_on_area_entered)
	hide()

func _process(delta: float) -> void:
	duration_timer += delta
	if duration_timer > current_duration:
		pass
		monitoring = false
		hide()

func _on_area_entered(area: Area3D):
	if area == attacker_entity.hurtbox:
		return
	
	if (can_hit or can_always_hit) and area.has_method("take_damage") and area.monitorable:
		can_hit = false
		if area.has_method("take_knockback"):
			area.take_knockback(current_knockback)
		area.take_damage(damage)
		if attacker_entity and attacker_entity.get("rhythm_camera") != null and attacker_entity.get("hit_effectiveness") != null:
			attacker_entity.rhythm_camera.rhythm_hit_camera_effect(attacker_entity.hit_effectiveness)

func hit(knockback: Vector3, damage: int = 1, duration: float = 0.05):
	can_hit = true
	duration_timer = 0.0
	current_knockback = knockback
	current_damage = damage
	current_duration = duration
	show()
	monitoring = true
