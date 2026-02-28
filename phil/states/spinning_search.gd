extends PhilState

var spin_direction = 1

func enter(previous_state_path: String, data := {}) -> void:
	spin_direction= [-1,1].pick_random()
	phil.velocity = Vector2.ZERO
	#Indicate
	phil.indicator_arrow.visible = true
	phil.indicator_arrow.position = Vector2(50,0)
	phil.direction = Vector2.from_angle(PI)
	
	var indicate_tween = get_tree().create_tween()
	if(spin_direction==1):
		phil.indicator_arrow.rotation = PI/2
		phil.arrow_pivot.rotation=PI/2
	else:
		phil.indicator_arrow.rotation = -PI/2
		phil.arrow_pivot.rotation=(3*PI)/2
	indicate_tween.tween_property(phil.arrow_pivot,"rotation",PI,.5)
	#indicate_tween.parallel().tween_property(phil.indicator_arrow,"rotation",(-1.5*PI),0.5)
	indicate_tween.tween_property(phil.indicator_arrow,"visible",false,0)
	await get_tree().create_timer(0.5).timeout
	phil.direction = Vector2.from_angle(PI)
	
	#viewcone
	
	
	phil.view_cone_enabled = true
	phil.view_angle = PI/8
	phil.view_length =0
	var view_length_tween = get_tree().create_tween()
	view_length_tween.tween_property(phil,"view_length",120,0.25)
	#phil.view_length = 90
	$"../../AnimatedSprite2D".play("idle")
	await get_tree().create_timer(3.0).timeout
	finished.emit("Idle")

func exit() -> void:
	phil.stop_detecting.emit()

func physics_update(_delta: float) -> void:
	phil.direction = phil.direction.rotated(0.12*spin_direction)
