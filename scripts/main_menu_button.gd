extends Button

@onready var hover_arrow: Label = $HoverArrow


func _ready() -> void:
	hover_arrow.hide()
	
	mouse_entered.connect(_on_hovered)
	focus_entered.connect(_on_focus)
	focus_exited.connect(_on_unfocus)
	
func _on_hovered():
	grab_focus()
	
func _on_focus():
	hover_arrow.show()
	
func _on_unfocus():
	hover_arrow.hide()
