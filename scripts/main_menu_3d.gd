extends Node3D

@onready var audio_stream_player_3d: AudioStreamPlayer3D = $Camera3D/AudioStreamPlayer3D

func _ready() -> void:
	audio_stream_player_3d.finished.connect(_on_audio_finished)
	
func _on_audio_finished() -> void:
	audio_stream_player_3d.play()
