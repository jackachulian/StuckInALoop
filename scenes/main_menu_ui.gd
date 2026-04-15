extends Control

@onready var main_menu_container: MarginContainer = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/MainMenuContainer
@onready var credits_container: MarginContainer = $ColorRect/MarginContainer/PanelContainer/VBoxContainer/MarginContainer/CreditsContainer

func open_credits():
	credits_container.show()
