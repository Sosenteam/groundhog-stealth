extends PhilState


func enter(previous_state_path: String, data := {}) -> void:
	phil.velocity = Vector2.ZERO
	$"../../AnimatedSprite2D".play("idle")
	phil.view_cone_enabled = false
	await get_tree().create_timer(0.25).timeout
	decide_state()



func physics_update(_delta: float) -> void:
	pass

func decide_state():
	var dist_between = abs(phil.position.distance_to(phil.player_ref.position))
	print(dist_between)
	if(phil.recent_states.size()>2):
		phil.recent_states.pop_front()
	var avaliable_states = []
	if(dist_between>70 && !phil.recent_states.has(BURROWING)):
		avaliable_states.append(BURROWING)
		if dist_between>200:
			avaliable_states.append(BURROWING)
			avaliable_states.append(BURROWING)
		if dist_between>350:
			phil.recent_states.append(BURROWING)
			finished.emit(BURROWING)
	if(dist_between<120):
		for i in range(1,3-phil.recent_states.count(SPINNINGSEARCH)):
			avaliable_states.append(SPINNINGSEARCH)
		for i in range(1,3-phil.recent_states.count(CIRCLESEARCH)):
			avaliable_states.append(CIRCLESEARCH)
	for i in range(1,3-phil.recent_states.count(FORWARDSEARCH)):
		avaliable_states.append(FORWARDSEARCH)
	
	var next_state = avaliable_states.pick_random()
	phil.recent_states.append(next_state)
	finished.emit(next_state)
