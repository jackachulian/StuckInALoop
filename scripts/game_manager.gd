class_name GameManager
extends Node3D

static var level = 0

@export var rhythm_manager: RhythmManager
@export var player: Player
@export var intro_music: AudioStream
@export var three_song_stitch: AudioStream
@onready var intro_cutscene: IntroCutscene = $IntroCutscene

@onready var level_0: Node3D = $"Level 0-Intro"
@onready var level_1: Node3D = $"Level 1"


func _ready() -> void:
	if level == 0:
		level_0.show()
		level_1.hide()
		rhythm_manager.music_player.stream = intro_music
		player.set_control(false)
		intro_cutscene.play()
	elif level == 1:
		level_0.hide()
		level_1.show()
		rhythm_manager.music_player.stream = three_song_stitch
		player.set_control(true)
		
	rhythm_manager.start_rhythming()
