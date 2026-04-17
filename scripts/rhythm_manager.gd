class_name RhythmManager
extends Node

@export var beats_per_minute: float = 170

@export var music_player: AudioStreamPlayer3D

var current_beat: float
var last_signaled_beat: int
var beats_per_second: float
var last_consumed_beat: int
var last_process_playback_pos: float

signal beat
	
func start_rhythming():
	beats_per_second = beats_per_minute / 60.0
	current_beat = ((OptionsManager.beat_offset_milliseconds / 1000.0) * beats_per_second) * -1
	last_signaled_beat = floor(current_beat)
	music_player.play()
	last_process_playback_pos = music_player.get_playback_position()
	
enum HitEffectiveness {
	Miss,
	Okay,
	Good,
	Great,
	Perfect
}

func consume_beat() -> HitEffectiveness:
	var input_delay_beats: float = (OptionsManager.input_delay_milliseconds / 1000.0) * beats_per_second
	var closest_beat: int = round(current_beat + input_delay_beats)
	
	if (last_consumed_beat == closest_beat):
		print("Miss! Tried to consume same beat twice")
		return HitEffectiveness.Miss
	last_consumed_beat = closest_beat
	
	var closest_beat_offset: float = closest_beat - current_beat
	var closest_beat_offset_seconds: float = closest_beat_offset / beats_per_second
	var next_beat_offset_seconds: float = (closest_beat+1 - current_beat) / beats_per_second
	
	var effectiveness_max_diffs := [999, 0.150, 0.125, 0.100, 0.075]
	var effectiveness := HitEffectiveness.Miss
	
	for i in range(1, len(effectiveness_max_diffs)):
		if abs(closest_beat_offset_seconds) < effectiveness_max_diffs[i]:
			effectiveness = i as HitEffectiveness
			
	print("effectiveness: ", effectiveness, ". offset: ", int(closest_beat_offset_seconds * 1000), "ms. next beat offset: ", int(next_beat_offset_seconds * 1000), "ms")
	return effectiveness
	
func _process(delta: float) -> void:
	var playback_pos = music_player.get_playback_position()
	if (playback_pos > 82.848):
		beats_per_second = 170.0 / 60.0
	
	
	current_beat += beats_per_second * (playback_pos - last_process_playback_pos)
	last_process_playback_pos = playback_pos
	
	if (last_signaled_beat + 1 <= current_beat):
		last_signaled_beat += 1
		#print("beat ", last_signaled_beat)
		beat.emit()
