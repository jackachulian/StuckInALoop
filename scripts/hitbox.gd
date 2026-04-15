class_name Hitbox
extends Area3D

@export var damage: int = 1

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

func _on_area_entered(body):
	print("body entered: ", body)
	if can_hit and body.has_method("take_damage"):
		can_hit = false
		body.take_damage(damage)
		if body.has_method("take_knockback"):
			body.take_knockback(current_knockback)

func hit(knockback: Vector3, damage: int = 1, duration: float = 0.25):
	can_hit = true
	duration_timer = 0.0
	current_knockback = knockback
	current_damage = damage
	current_duration = duration
	show()
	monitoring = true
