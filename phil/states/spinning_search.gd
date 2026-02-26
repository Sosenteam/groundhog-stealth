extends PhilState


func enter(previous_state_path: String, data := {}) -> void:
	phil.velocity = Vector2.ZERO
	#Indicate
	phil.indicator_arrow.visible = true
	phil.indicator_arrow.position = Vector2(30,0)
	phil.indicator_arrow.rotation = PI/2
	phil.direction = Vector2.from_angle(PI)
	phil.arrow_pivot.rotation=0
	var indicate_tween = get_tree().create_tween()
	indicate_tween.tween_property(phil.arrow_pivot,"rotation",PI,.5)
	#indicate_tween.parallel().tween_property(phil.indicator_arrow,"rotation",(-1.5*PI),0.5)
	indicate_tween.tween_property(phil.indicator_arrow,"visible",false,0)
	await get_tree().create_timer(0.5).timeout
	phil.direction = Vector2.from_angle(PI)
	
	#viewcone
	
	
	phil.view_cone_enabled = true
	phil.view_angle = PI/5
	phil.view_length = 100
	$"../../AnimatedSprite2D".play("idle")
	await get_tree().create_timer(3.0).timeout
	finished.emit("Idle")


func physics_update(_delta: float) -> void:
	phil.direction = phil.direction.rotated(0.06)
