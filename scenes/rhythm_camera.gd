class_name RhythmCamera
extends Camera3D

const eff_strengths = [0.0, 0.25, 0.4, 0.6, 1.00]

var start_fov: float
var current_tween: Tween

func _ready() -> void:
	start_fov = fov

func rhythm_hit_camera_effect(effectiveness: RhythmManager.HitEffectiveness):
	var strength = eff_strengths[effectiveness]
	
	fov = start_fov - 2.25 * strength
	rotation_degrees = Vector3(0.0, 0.0, randf_range(-8.0, 8.0) * strength)
	
	if current_tween:
		current_tween.kill()
	
	current_tween = get_tree().create_tween()
	#current_tween.tween_property(self, "position", start_position + Vector3.UP * 1.5, 0.2) \
	#.set_ease(Tween.EASE_IN_OUT)
	current_tween.tween_property(self, "rotation_degrees", Vector3.ZERO, 0.06) \
	.set_ease(Tween.EASE_OUT)
	current_tween.tween_property(self, "fov", start_fov, 0.06) \
	.set_ease(Tween.EASE_OUT)
