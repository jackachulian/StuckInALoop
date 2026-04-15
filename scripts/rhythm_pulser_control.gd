class_name RhythmPulserControl
extends Control

@export var rhythm_manager: RhythmManager
@export var pulse_scale: float = 1.5
@export var pulse_time: float = 0.125

var start_scale: Vector2
var last_pulse_beat: int = 0

func _ready() -> void:
	start_scale = scale
	last_pulse_beat = floor(rhythm_manager.current_beat)

func _process(_delta: float) -> void:
	# If the current pulse should have happened by now, do the pulse
	if (rhythm_manager.current_beat + (_delta * rhythm_manager.beats_per_second) > last_pulse_beat + 1):
		last_pulse_beat = floor(rhythm_manager.current_beat)
		scale = start_scale * pulse_scale
		var tween = create_tween()
		tween.tween_property(self, "scale", start_scale, pulse_time)
