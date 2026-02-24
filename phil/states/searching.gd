extends PhilState


func enter(previous_state_path: String, data := {}) -> void:
	phil.velocity = Vector2.ZERO
	phil.view_cone_enabled = true


func physics_update(_delta: float) -> void:
	pass
