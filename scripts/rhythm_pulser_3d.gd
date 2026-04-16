class_name RhythmPulser3D
extends Node3D

@export var rhythm_manager: RhythmManager
@export var pulse_scale: Vector3 = Vector3.ONE
@export var pulse_time: float = 0.125

var start_scale: Vector3

func _ready() -> void:
	start_scale = scale
	rhythm_manager.beat.connect(_on_beat)

func _on_beat() -> void:
	# If the current pulse should have happened by now, do the pulse
	scale = start_scale * pulse_scale
	var tween = create_tween()
	tween.tween_property(self, "scale", start_scale, pulse_time)
