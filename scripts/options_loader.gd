extends Node

func _enter_tree() -> void:
	OptionsManager.load_config()
	
func _exit_tree() -> void:
	OptionsManager.save_config()
