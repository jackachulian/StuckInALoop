extends Area3D

@export var game_manager: GameManager
@export var player: Player

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	
func _on_body_entered(body: Node3D):
	if body == player:
		player.note_player.play()
		game_manager.add_points(100)
		queue_free()
