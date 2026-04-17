extends Label

@export var game_manager: GameManager

func _ready() -> void:
	_on_points_increased()
	game_manager.points_increased.connect(_on_points_increased)
	
func _on_points_increased():
	text = str(game_manager.points)
