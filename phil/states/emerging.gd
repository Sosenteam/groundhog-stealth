extends PhilState

@export var emerge_time = 0.2


func enter(previous_state_path: String, data := {}) -> void:
	await get_tree().create_timer(emerge_time).timeout
	finished.emit(IDLE)

func physics_update(_delta: float) -> void:
	pass

func exit() -> void:
	phil.set_collision_layer_value(1,true)
	phil.set_collision_mask_value(1,true)
