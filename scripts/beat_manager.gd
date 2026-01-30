class_name BeatManager
extends Node

signal beat(beat_time: float)

@export var bpm := 140.0
@export var start_immediately := true

var _seconds_per_beat := 0.0
var _song_time := 0.0
var _timer := 0.0
var _active := false

func _ready():
	_seconds_per_beat = 60.0 / bpm
	if start_immediately:
		start()

func start():
	_timer = 0.0
	_active = true

func stop():
	_active = false

func set_bpm(new_bpm: float):
	bpm = max(new_bpm, 1.0)
	_seconds_per_beat = 60.0 / bpm

func _process(delta):
	if not _active:
		return

	_song_time += delta # or could get this from the audio player
	_timer += delta
	if _timer >= _seconds_per_beat:
		_timer -= _seconds_per_beat
		emit_signal("beat")
