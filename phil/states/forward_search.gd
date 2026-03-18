extends PhilState


func enter(previous_state_path: String, data := {}) -> void:
	phil.velocity = Vector2.ZERO
	phil.direction= (phil.player_ref.position-phil.position).normalized()
	phil.direction.rotated(randf_range(-PI/6,PI/6))
	#Indicate
	phil.arrow_pivot.rotation = 0
	phil.indicator_arrow.visible = true
	phil.indicator_arrow.position = phil.direction*20
	phil.indicator_arrow.rotation = phil.direction.angle()
	var indicate_tween = get_tree().create_tween()
	indicate_tween.tween_property(phil.indicator_arrow,"position",phil.direction*50,.75).set_trans(Tween.TRANS_EXPO)
	indicate_tween.tween_property(phil.indicator_arrow,"visible",false,0)
	#viewcone
	phil.view_cone_enabled = true
	phil.view_angle = PI/6.5
	# Make Viewlength Stretch
	phil.view_length = 0
	var view_length_tween = get_tree().create_tween()
	view_length_tween.tween_property(phil,"view_length",500,2).set_trans(Tween.TRANS_EXPO)
	$"../../AnimatedSprite2D".play("idle")
	await get_tree().create_timer(2.0).timeout
	finished.emit("Idle")

func exit() -> void:
	phil.stop_detecting.emit()

func physics_update(_delta: float) -> void:
	pass
