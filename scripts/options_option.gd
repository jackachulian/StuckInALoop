extends PanelContainer

@export var normal_style: StyleBox
@export var hover_style: StyleBox

func _ready() -> void:
	add_theme_stylebox_override("panel", normal_style)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	if hover_style: add_theme_stylebox_override("panel", hover_style)

func _on_mouse_exited():
	add_theme_stylebox_override("panel", normal_style)
