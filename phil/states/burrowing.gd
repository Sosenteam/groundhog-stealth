extends PhilState

var target_position: Vector2

func enter(previous_state_path: String, data := {}) -> void:
	phil.velocity = Vector2.ZERO
	phil.view_cone_enabled = false
	$"../../AnimatedSprite2D".play("burrowing")
	phil.set_collision_layer_value(1,false)
	phil.set_collision_mask_value(1,false)

	target_position = phil.player_ref.position+Vector2(randf_range(-20,20),randf_range(-20,20))



func physics_update(_delta: float) -> void:
	var direction = (target_position-phil.position).normalized()
	phil.velocity = direction*phil.speed
	phil.move_and_slide()
	if (phil.position-target_position).length() < 20:
		var space_state = phil.get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = phil.position
		query.collision_mask = 1
		query.collide_with_areas = false
		query.collide_with_bodies = true
		
		if space_state.intersect_point(query).size() > 0 or phil.position.distance_to(phil.player_ref.position) < 40.0:
			var next_target = target_position + direction * 30
			if next_target.x < -130 or next_target.x > 130 or next_target.y < -130 or next_target.y > 130:
				direction = (Vector2.ZERO - phil.position).normalized()
				target_position += direction * 30
			else:
				target_position = next_target
		else:
			phil.set_collision_layer_value(1,true)
			phil.set_collision_mask_value(1,true)
			finished.emit(EMERGING)

func exit() -> void:
	pass
