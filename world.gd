extends Node2D

@onready var level_container = $LevelContainer
@onready var countdown = $CountdownTimer

@export var debug = {
	"show_countdown": true,
}

var current_level_node = null

@onready var player_node = $Player
@onready var phil_node = $Phil
const clock_scene = preload("res://clock.tscn")
const win_scene = preload("res://win_screen.tscn")
const phil_scene = preload("res://phil/phil.tscn")
var active_clock: Node
var win_node: Node
var runWin = true

@export var gameoverScreenPrefab: PackedScene;


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
	get_tree().paused = false
	get_tree().reload_current_scene()

func _ready() -> void:
	# creating clock
	active_clock = clock_scene.instantiate()
	active_clock.setup(20.0)
	add_child(active_clock)
	
	# Connect countdown signal to start the clock and start phil and player
	countdown.countdown_finished.connect(active_clock.start_counting)
	countdown.countdown_finished.connect(_on_countdown_finished)
	
	# Pause player and phil to start game
	#player_node.process_mode = PROCESS_MODE_DISABLED
	#phil_node.process_mode = PROCESS_MODE_DISABLED
	#level_container.process_mode = PROCESS_MODE_DISABLED
	get_tree().paused = true
	
	
	load_level("res://levels/template level.tscn")


func _on_countdown_finished():
	#player_node.process_mode = PROCESS_MODE_INHERIT
	#phil_node.process_mode = PROCESS_MODE_INHERIT
	#level_container.process_mode = PROCESS_MODE_INHERIT
	var new_phil = phil_scene.instantiate()
	add_child(new_phil)
	get_tree().paused = false

func _on_detected() -> void:
	runWin = false;
	var instance = gameoverScreenPrefab.instantiate();
	add_child(instance);
