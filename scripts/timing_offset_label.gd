extends Label

@export var normal_label_settings: LabelSettings
@export var hover_label_settings: LabelSettings
@export var focus_label_settings: LabelSettings

var is_focused: bool
var is_hovered: bool

func _ready():
	focus_entered.connect(_on_focus_entered)
	focus_exited.connect(_on_focus_exited)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
func _on_focus_entered():
	is_focused = true
	update_label_settings()
	
func _on_focus_exited():
	is_focused = false
	update_label_settings()
	
func _on_mouse_entered():
	is_hovered = true
	update_label_settings()
	
func _on_mouse_exited():
	is_hovered = false
	update_label_settings()
	
func update_label_settings():
	if is_focused:
		label_settings = focus_label_settings
	elif is_hovered:
		label_settings = hover_label_settings
	else:
		label_settings = normal_label_settings
