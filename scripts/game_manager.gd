class_name GameManager
extends Node3D

static var points: int = 0
static var level = 0

@export var rhythm_manager: RhythmManager
@export var player: Player
@export var intro_music: AudioStream
@export var three_song_stitch: AudioStream
@onready var health_indicator: AnimatedSprite2D = $CanvasLayer/UI/HealthIndicator

@onready var intro_cutscene: IntroCutscene = $IntroCutscene
@onready var intro_map: Node3D = $"Level 0-Intro"
@onready var level1_map: Node3D = $"Level 1"
#@onready var level2_map: Node3D = $"Level 2"
#@onready var level3_map: Node3D = $"Level 3"

signal points_increased

func _ready() -> void:
	if level == 0:
		intro_map.show()
		level1_map.queue_free()
		#level2_map.queue_free()
		#level3_map.queue_free()
		rhythm_manager.music_player.stream = intro_music
		rhythm_manager.beats_per_minute = 95
		player.set_control(false)
		intro_cutscene.play()
	elif level == 1:
		intro_map.queue_free()
		level1_map.show()
		level1_map.process_mode = Node.PROCESS_MODE_INHERIT
		#level2_map.hide()
		#level1_map.process_mode = Node.PROCESS_MODE_DISABLED
		#level3_map.hide()
		#level1_map.process_mode = Node.PROCESS_MODE_DISABLED
		rhythm_manager.music_player.stream = three_song_stitch
		rhythm_manager.beats_per_minute = 168
		player.set_control(true)
		
	rhythm_manager.start_rhythming()
	health_indicator._on_player_health_changed()

#func start_level_2():
	#level1_map.hide()
	#level1_map.process_mode = Node.PROCESS_MODE_DISABLED
	#level2_map.show()
	#level1_map.process_mode = Node.PROCESS_MODE_INHERIT
	#level3_map.hide()
	#level1_map.process_mode = Node.PROCESS_MODE_DISABLED
	#
#func start_level_3():
	#level1_map.hide()
	#level1_map.process_mode = Node.PROCESS_MODE_DISABLED
	#level2_map.hide()
	#level1_map.process_mode = Node.PROCESS_MODE_DISABLED
	#level3_map.show()
	#level1_map.process_mode = Node.PROCESS_MODE_INHERIT

func add_points(amount: int):
	points += amount
	points_increased.emit()
