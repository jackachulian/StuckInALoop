class_name RhythmManager
extends Node

@export var options_manager: OptionsManager

@export var beats_per_minute: float = 170

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"../Player/Camera3D/AudioStreamPlayer3D"

var current_beat: float
var last_signaled_beat: int
var beats_per_second: float
var last_consumed_beat: int

signal beat

func _ready() -> void:
	# Start slightly behind the beat based on timing offset 
	current_beat = ((options_manager.beat_offset_milliseconds / 1000.0) * beats_per_second) * -1
	last_signaled_beat = floor(current_beat)
	beats_per_second = beats_per_minute / 60.0
	
enum HitEffectiveness {
	Miss,
	Okay,
	Good,
	Great,
	Perfect
}

func consume_beat() -> HitEffectiveness:
	var input_delay_beats: float = (options_manager.input_delay_milliseconds / 1000.0) * beats_per_second
	var closest_beat: int = round(current_beat + input_delay_beats)
	if (last_consumed_beat == closest_beat):
		print("Miss! Tried to consume same beat twice")
		return HitEffectiveness.Miss
	last_consumed_beat = closest_beat
	
	var closest_beat_offset: float = closest_beat - current_beat
	var closest_beat_offset_seconds: float = closest_beat_offset / beats_per_second
	
	var effectiveness_max_diffs := [999, 0.11, 0.09, 0.07, 0.05]
	var effectiveness := HitEffectiveness.Miss
	
	for i in range(1, len(effectiveness_max_diffs)):
		if abs(closest_beat_offset_seconds) < effectiveness_max_diffs[i]:
			effectiveness = i as HitEffectiveness
			
	print("effectiveness: ", effectiveness, " (offset: ", snapped(closest_beat_offset_seconds, 0.001), ")")
	return effectiveness
	
func _process(delta: float) -> void:
	current_beat += beats_per_second * delta
	
	if (last_signaled_beat + 1 <= current_beat):
		beat.emit()
		last_signaled_beat += 1
