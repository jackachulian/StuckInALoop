extends Control

@export var scene_transition: SceneTransition
@export var confirm_sound_player: AudioStreamPlayer3D
@export var highlight_sound_player: AudioStreamPlayer3D

@onready var main_menu_container: MarginContainer = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/MainMenuContainer
@onready var credits_container: MarginContainer = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/CreditsContainer
@onready var options_container: MarginContainer = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/OptionsContainer

@onready var credits_back_button: Button = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/CreditsContainer/PanelContainer/VBoxContainer/BackButton


@onready var play_button: Button = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/MainMenuContainer/HBoxContainer/PanelContainer2/VBoxContainer/PlayButton
@onready var credits_button: Button = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/MainMenuContainer/HBoxContainer/PanelContainer2/VBoxContainer/CreditsButton
@onready var options_button: Button = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/MainMenuContainer/HBoxContainer/PanelContainer2/VBoxContainer/OptionsButton
@onready var quit_button: Button = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/MainMenuContainer/HBoxContainer/PanelContainer2/VBoxContainer/QuitButton



func _ready() -> void:
	credits_container.hide()
	options_container.hide()
	
	play_button.grab_focus()
	
func _on_play_pressed():
	confirm_sound_player.play()
	scene_transition.transition_to_scene("res://scenes/level.tscn")

func _on_credits_pressed():
	if (scene_transition.is_animating): return
	confirm_sound_player.play()
	credits_container.show()
	#credits_back_button.grab_focus()

func _on_credits_back_pressed():
	credits_container.hide()
	credits_button.grab_focus()

func _on_options_pressed():
	if (scene_transition.is_animating): return
	confirm_sound_player.play()
	options_container.show()

func _on_options_back_pressed():
	options_container.hide()
	options_button.grab_focus()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
