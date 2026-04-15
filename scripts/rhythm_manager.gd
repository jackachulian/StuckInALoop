class_name RhythmManager
extends Node

@export var options_manager: OptionsManager

@export var beats_per_second: float = 168.0/60.0

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $"../Player/Camera3D/AudioStreamPlayer3D"

var current_beat: float

func _ready() -> void:
	# Start slightly behind the beat based on timing offset 
	current_beat = ((options_manager.beat_offset_milliseconds / 1000.0) * beats_per_second) * -1
	
func _process(delta: float) -> void:
	current_beat += beats_per_second * delta
