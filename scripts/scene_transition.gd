class_name SceneTransition
extends CanvasLayer

static var is_animating: bool = false

@onready var rect: ColorRect = $AspectRatioContainer/ColorRect
@onready var mat: Material = rect.material

func _ready() -> void:
	if is_animating:
		mat.set("shader_parameter/outer_radius", 1.0)
		open()
	else:
		mat.set("shader_parameter/outer_radius", 0.0)

func transition_to_scene(scene_path: String):
	await close()
	mat.set("shader_parameter/outer_radius", 1.0)
	await get_tree().process_frame
	get_tree().change_scene_to_file(scene_path)
	await open()

func close() -> Signal:
	is_animating = true
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/outer_radius", 1.0, 0.7)
	return tween.finished

func open() -> Signal:
	var tween = create_tween()
	tween.tween_property(mat, "shader_parameter/outer_radius", 0.0, 0.7)
	return tween.finished
