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
var active_clock: Node
var win_node: Node
var runWin = true

@export var gameoverScreenPrefab:PackedScene;

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


func _physics_process(delta: float) -> void:
	pass
	
func _process(delta: float) -> void:
	#Getting if time ran out, if so, show win screen
	#!!FOR NOW ONLY RUNS ONCE!!
	#print(active_clock.getTimeInSeconds())
	if active_clock.getTimeInSeconds() == 0.0 && runWin == true:
		win_node = win_scene.instantiate()
		add_child(win_node)
		#load new win scene
		runWin = false
		$DetectionLayer/DetectionMeter.canDie = false;
		$DetectionLayer/DetectionMeter.canBeSeen = false
		print("hhs")
		active_clock.time_left = -1.0
	if win_node != null:
		print(win_node.get_kill_me())
	if win_node != null && win_node.get_kill_me():
		print("hello")
		$WinScreen.queue_free()
		$WinScreen.hide()

func _ready() -> void:
	# creating clock
	active_clock = clock_scene.instantiate()
	active_clock.setup(5.0)
	add_child(active_clock)
	
	# Connect countdown signal to start the clock
	countdown.countdown_finished.connect(active_clock.start_counting)
	
	load_level("res://levels/template level.tscn")


func _on_detected() -> void:
	runWin = false;
	var instance = gameoverScreenPrefab.instantiate();
	add_child(instance);
