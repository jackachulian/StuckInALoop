extends ColorRect

@export var rhythm_manager: RhythmManager



func _ready() -> void:
	rhythm_manager.beat.connect(_on_beat)
	
func _on_beat():
	material.set("shader_parameter/dots_width", 2.316)
	create_tween().tween_property(material, "shader_parameter/dots_width", 2.246, 0.125)
