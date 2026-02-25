extends PhilState


func enter(previous_state_path: String, data := {}) -> void:
	phil.velocity = Vector2.ZERO
	$"../../AnimatedSprite2D".play("idle")
	phil.view_cone_enabled = false
	await get_tree().create_timer(3.0).timeout
	$"../../StateMachine"._random_state()



func physics_update(_delta: float) -> void:
	pass
