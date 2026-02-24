extends PhilState

var target_position: Vector2

func enter(previous_state_path: String, data := {}) -> void:
	phil.velocity = Vector2.ZERO
	phil.view_cone_enabled = false
	# REPLACE THIS CODE PLEASE
	if($"../../../Player"):
		target_position = $"../../../Player".position+Vector2(randf_range(-20,20),randf_range(-20,20))



func physics_update(_delta: float) -> void:
	var direction = (target_position-phil.position).normalized()
	phil.velocity = direction*phil.speed
	phil.move_and_slide()
	if((phil.position-target_position).length() <20):
		finished.emit(IDLE)
