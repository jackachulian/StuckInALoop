extends Control

@onready var main_menu_container: MarginContainer = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/MainMenuContainer
@onready var credits_container: MarginContainer = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/CreditsContainer
@onready var options_container: MarginContainer = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/OptionsContainer


func _ready() -> void:
	credits_container.hide()

func _on_credits_pressed():
	credits_container.show()

func _on_credits_back_pressed():
	credits_container.hide()

func _on_options_pressed():
	options_container.show()

func _on_options_back_pressed():
	options_container.hide()
