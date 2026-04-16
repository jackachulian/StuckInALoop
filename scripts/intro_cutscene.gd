class_name IntroCutscene
extends Node

@export var player: Player
@export var count_p_wright: CountPWright
@export var scene_transition: SceneTransition

func play():
	player.animated_sprite_3d.play("intro")
	count_p_wright.hide()
	count_p_wright.hide_hands()
	
	var tween = create_tween()
	var start_camera_pos = player.rhythm_camera.global_position
	tween.tween_property(player.rhythm_camera, "global_position", start_camera_pos + Vector3(4.0, 1.5, 0.0), 1.0).set_delay(3.0).set_ease(Tween.EASE_IN_OUT)
	
	await get_tree().create_timer(3.847).timeout
	player.animated_sprite_3d.play("intro_wildtake")
	count_p_wright.show()
	count_p_wright.show_hands()
	await get_tree().create_timer(1.5).timeout
	player.animated_sprite_3d.play("idle")

	await get_tree().create_timer(4.0).timeout
	GameManager.level = 1
	scene_transition.transition_to_scene("res://scenes/level.tscn")
