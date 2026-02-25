extends PhilState


func enter(previous_state_path: String, data := {}) -> void:
	phil.velocity = Vector2.ZERO
	phil.view_cone_enabled = true
	phil.view_angle = PI/6
	phil.view_length = 500
	$"../../AnimatedSprite2D".play("idle")
	await get_tree().create_timer(3.0).timeout
	finished.emit("Idle")


func physics_update(_delta: float) -> void:
	pass
