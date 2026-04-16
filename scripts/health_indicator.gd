extends AnimatedSprite2D

@export var rhythm_manager: RhythmManager
@export var player: Player

func _ready() -> void:
	_on_player_health_changed()
	player.health_changed.connect(_on_player_health_changed)

func _on_player_health_changed():
	match player.health:
		4: play_animation_synced("4", 2)
		3: play_animation_synced("3", 2)
		2: play_animation_synced("2", 2)
		1: play_animation_synced("1", 2)

func play_animation_synced(anim: StringName, anim_beat_length: float = 1.0, beat_offset: float = 0.0) -> void:
	animation = anim
	var frame_count = sprite_frames.get_frame_count(anim)
	var anim_time = anim_beat_length / rhythm_manager.beats_per_second
	var anim_fps = frame_count / anim_time
	
	var offset_beat = rhythm_manager.current_beat + beat_offset
	var anim_progress = (offset_beat / anim_beat_length) - floor(offset_beat / anim_beat_length)
	var play_frame = floor(anim_progress * frame_count)
	var play_frame_progress = (anim_progress * frame_count) - floor(anim_progress * frame_count)
	play(anim)
	sprite_frames.set_animation_speed(anim, anim_fps)
	set_frame_and_progress(play_frame, play_frame_progress)
	#print("playing ", anim, " at fps=", anim_fps, " frame=", frame, " frame_progess=", frame_progress)
