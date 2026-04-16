class_name RhythmEffectivenessText
extends Label3D

@export var effectiveness_texts := ["MISS", "MEH", "GOOD", "SWEET", "PEAK"]
@export var effectiveness_colors := [Color.GRAY, Color.RED, Color.YELLOW, Color.GREEN, Color.CYAN]

var start_position: Vector3
var current_tween: Tween
var timer: Timer

func _ready() -> void:
	start_position = position
	modulate = Color.TRANSPARENT
	outline_modulate = Color.TRANSPARENT

func show_effectiveness(effectiveness: RhythmManager.HitEffectiveness):
	text = effectiveness_texts[effectiveness]
	modulate = effectiveness_colors[effectiveness]
	outline_modulate = Color.BLACK

	position = start_position
	rotation_degrees = Vector3(0.0, 0.0, randf_range(-10, 10))

	if current_tween:
		current_tween.kill()
		
	await get_tree().create_timer(0.15).timeout

	current_tween = get_tree().create_tween()
	#current_tween.tween_property(self, "position", start_position + Vector3.UP * 1.5, 0.2) \
	#.set_ease(Tween.EASE_IN_OUT)
	current_tween.tween_property(self, "modulate", Color(modulate.r, modulate.g, modulate.b, 0.0), 0.1) \
	.set_ease(Tween.EASE_OUT)
	current_tween.tween_property(self, "outline_modulate", Color(0,0,0,0), 0.1) \
	.set_ease(Tween.EASE_OUT)
