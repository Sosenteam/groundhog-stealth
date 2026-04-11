extends Node2D

@onready var level_container = $LevelContainer
@onready var countdown = $CountdownTimer

@export var debug = {
	"show_countdown": true,
}

var current_level_node = null

@onready var player_node = $Player
const clock_scene = preload("res://clock.tscn")
const win_scene = preload("res://win_screen.tscn")
const phil_scene = preload("res://phil/phil.tscn")
const coin_ui_scene = preload("res://coin_ui.tscn")
var active_clock: Node
var win_node: Node
var coin_ui_node: Node
var runWin = true
var current_phil_ref: Node = null
var halfway_coin_spawned = false

@export var gameoverScreenPrefab: PackedScene

const STRUC_ROCK = preload("res://rock.tscn")
const STRUC_STUMP = preload("res://stump.tscn")
const STRUC_BUSH = preload("res://bush.tscn")


func load_level(level_path: String):
	if current_level_node:
		current_level_node.queue_free()

	var level_resource = load(level_path)
	current_level_node = level_resource.instantiate()

	level_container.add_child(current_level_node)

	if debug.get("show_countdown", true):
		countdown.start_countdown()
	else:
		countdown.hide()
		countdown.countdown_finished.emit()


func _physics_process(_delta: float) -> void:
	pass
	
func _process(_delta: float) -> void:
	#Getting if time ran out, if so, show win screen
	if active_clock.getTimeInSeconds() <= 30.0 and not halfway_coin_spawned:
		halfway_coin_spawned = true
		if current_phil_ref:
			var coin = preload("res://coins/coin.tscn").instantiate()
			coin.position = current_phil_ref.position
			level_container.add_child(coin)

	if active_clock.getTimeInSeconds() == 0.0 && runWin == true:
		win_node = win_scene.instantiate()
		add_child(win_node)
		win_node.win_finished.connect(_on_win_finished)
		runWin = false
		get_tree().paused = true
		$DetectionLayer/DetectionMeter.canDie = false
		$DetectionLayer/DetectionMeter.canBeSeen = false
		active_clock.time_left = -1.0

func _on_win_finished() -> void:
	if win_node:
		win_node.queue_free()
		win_node = null
		
	var round_num = get_tree().root.get_meta("round_number", 1)
	get_tree().root.set_meta("round_number", round_num + 1)
	
	get_tree().paused = false
	get_tree().reload_current_scene()

func _ready() -> void:
	var transition_layer = CanvasLayer.new()
	transition_layer.layer = 100
	var overlay = ColorRect.new()
	overlay.color = Color.BLACK
	overlay.anchors_preset = 15 # PRESET_FULL_RECT
	transition_layer.add_child(overlay)
	add_child(transition_layer)
	
	var fade_in = create_tween()
	fade_in.tween_property(overlay, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_CUBIC)
	fade_in.finished.connect(transition_layer.queue_free)

	# creating clock
	active_clock = clock_scene.instantiate()
	active_clock.setup(60.0)
	add_child(active_clock)
	
	# creating coin UI
	coin_ui_node = coin_ui_scene.instantiate()
	add_child(coin_ui_node)
	
	var current_coins = get_tree().root.get_meta("total_coins", 0)
	player_node.coinCount = current_coins
	coin_ui_node.update_coins(current_coins)
	
	player_node.coins_changed.connect(_on_player_coins_changed)
	
	# Connect countdown signal to start the clock and start phil and player
	countdown.countdown_finished.connect(active_clock.start_counting)
	countdown.countdown_finished.connect(_on_countdown_finished)
	
	# Pause player and phil to start game
	#player_node.process_mode = PROCESS_MODE_DISABLED
	#phil_node.process_mode = PROCESS_MODE_DISABLED
	#level_container.process_mode = PROCESS_MODE_DISABLED
	get_tree().paused = true
	
	load_level("res://levels/template level.tscn")
	
	var round_num = get_tree().root.get_meta("round_number", 1)
	if round_num <= 3:
		var obstacles_to_spawn = 4 - round_num
		spawn_random_obstacles(obstacles_to_spawn)

func spawn_random_obstacles(count: int) -> void:
	var scenes = [STRUC_ROCK, STRUC_STUMP, STRUC_BUSH]
	var p_pos = Vector2(-104, 0)
	var ph_pos = Vector2(0, 0)
	for i in range(count):
		var valid = false
		var pos = Vector2.ZERO
		for j in range(15):
			pos = Vector2(randf_range(-120, 120), randf_range(-120, 120))
			if pos.distance_to(p_pos) > 40 and pos.distance_to(ph_pos) > 40:
				valid = true
				break
		if valid:
			var obs = scenes.pick_random().instantiate()
			obs.position = pos
			level_container.add_child(obs)


func _on_countdown_finished():
	#player_node.process_mode = PROCESS_MODE_INHERIT
	#phil_node.process_mode = PROCESS_MODE_INHERIT
	#level_container.process_mode = PROCESS_MODE_INHERIT
	var new_phil = phil_scene.instantiate()
	current_phil_ref = new_phil
	add_child(new_phil)
	$DetectionLayer/DetectionMeter.connect_phil(new_phil)
	get_tree().paused = false

func _on_player_coins_changed(count: int) -> void:
	get_tree().root.set_meta("total_coins", count)
	coin_ui_node.update_coins(count)

func _on_detected() -> void:
	runWin = false
	
	# Save Score to Database
	var user = get_tree().root.get_meta("username", "AAA")
	var coins = get_tree().root.get_meta("total_coins", 0)
	
	var file = FileAccess.open("user://scores.json", FileAccess.READ)
	var scores = []
	if file:
		var json = JSON.parse_string(file.get_as_text())
		if typeof(json) == TYPE_ARRAY:
			scores = json
		file.close()
		
	scores.append({"user": user, "coins": coins})
	scores.sort_custom(func(a,b): return a.coins > b.coins)
	
	var out_file = FileAccess.open("user://scores.json", FileAccess.WRITE)
	out_file.store_string(JSON.stringify(scores))
	out_file.close()
	
	# Reset rounds and coins when player loses
	get_tree().root.set_meta("round_number", 1)
	get_tree().root.set_meta("total_coins", 0)
	
	var instance = gameoverScreenPrefab.instantiate()
	add_child(instance)
