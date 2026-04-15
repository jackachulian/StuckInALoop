class_name BeatBar
extends ColorRect

@export var beats_per_second: float = 170.0/60.0
@export var beat_lookahead: float = 2.5
@export var marker_scene: PackedScene

@export var center_pulse_scale: float = 1.5
@export var center_pulse_time: float = 0.125

@onready var beat_markers: Control = $BeatMarkers
@onready var beat_center: Control = $BeatCenter
@onready var audio_stream_player: AudioStreamPlayer3D = $"../../../Player/Camera3D/AudioStreamPlayer3D"

var beat_offset_seconds: float = 0.100

var current_beat: float
var last_pulse_beat: int = 0
var last_marker_spawn_beat: int = 0

func _ready() -> void:
	# Cannot spawn markers for beats that happened in the past
	while last_marker_spawn_beat < beat_lookahead:
		last_marker_spawn_beat += 1
		
	#beat_offset_time = AudioServer.get_output_latency()
	current_beat = (beat_offset_seconds * beats_per_second) * -1
	print("beat offset seconds: ",beat_offset_seconds)

func _process(delta: float) -> void:
	current_beat += beats_per_second * delta
	
	if (current_beat > last_pulse_beat + 1):
		last_pulse_beat += 1
		beat_center.scale = Vector2(center_pulse_scale, center_pulse_scale)
		var tween = create_tween()
		tween.tween_property(beat_center, "scale", Vector2.ONE, center_pulse_time)
	
	if (current_beat + beat_lookahead) >= last_marker_spawn_beat:
		print("spawning markers for beat ", last_marker_spawn_beat)
		spawn_markers()
		last_marker_spawn_beat += 1
		
	

func spawn_markers():
	var center = global_position + (size / 2)
	var left_edge = Vector2(global_position.x, global_position.y + size.y/2)
	var right_edge = Vector2(global_position.x + size.x, global_position.y + size.y/2)
	
	var lookahead_time: float = beat_lookahead / beats_per_second
	
	var left_marker = marker_scene.instantiate() as BeatMarker
	beat_markers.add_child(left_marker)
	left_marker.animate_move(left_edge, center, lookahead_time)
	
	var right_marker = marker_scene.instantiate() as BeatMarker
	right_marker.flip_h = true
	beat_markers.add_child(right_marker)
	right_marker.animate_move(right_edge, center, lookahead_time)
