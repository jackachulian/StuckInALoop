# Attach this to your main camera or a central input handler
extends Camera3D

@export var ui_viewport: SubViewport
@export var ui_object: CollisionObject3D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		var from = project_ray_origin(event.position)
		var to = from + project_ray_normal(event.position) * 1000

		var space_state = get_world_3d().direct_space_state
		var params := PhysicsRayQueryParameters3D.new()
		params.from = from
		params.to = to
		params.collision_mask = 1
		var result = space_state.intersect_ray(params)
	
		if result and result.collider == ui_object:
			var local_hit = ui_object.to_local(result.position)
			var mesh_size = Vector2(1.0, 0.6) # width, height of your plane in 3D units

			# Map local position to UV (0..1)
			var uv = Vector2(
				(local_hit.x / mesh_size.x) + 0.5,
				(local_hit.y / mesh_size.y) + 0.5
			)
			
			var vp_size = ui_viewport.size
			var ui_pos = Vector2(uv.x * vp_size.x, (1.0 - uv.y) * vp_size.y)

			# Duplicate the event and adjust position
			var ui_event = event.duplicate()
			if ui_event is InputEventMouse:
				ui_event.position = ui_pos

			ui_viewport.push_input(ui_event)
