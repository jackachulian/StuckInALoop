class_name Dialogue
extends Control

@onready var dialogue_arrow_left: Polygon2D = $DialogueArrowLeft
@onready var dialogue_arrow_right: Polygon2D = $DialogueArrowRight

@onready var text_label: Label = $Control/MarginContainer/TextLabel
#@onready var speaker_name_label: Label = $Control2/MarginContainer/SpeakerNameLabel

func _ready() -> void:
	hide()

func show_dialogue(text: String):
	show()
	text_label.text = text
	#speaker_name_label.text = speaker_name
	
	#if is_right:
		#dialogue_arrow_right.show()
		#dialogue_arrow_left.hide()
	#else:
		#dialogue_arrow_right.hide()
		#dialogue_arrow_left.show()
