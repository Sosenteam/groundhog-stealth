extends Node2D

@onready var level_container = $LevelContainer
@onready var countdown = $CountdownTimer

@export var debug = {
	"show_countdown": true,
}

var current_level_node = null

@onready var player_node = $Player
const clock_scene = preload("res://clock.tscn")
var active_clock: Node
func _ready():
	# countdown.countdown_finished.connected(_start_level_clock)
	load_level("res://levels/template level.tscn")

func load_level(level_path: String):
	if current_level_node:
		current_level_node.queue_free()

	var level_resource = load(level_path)
	current_level_node = level_resource.instantiate()

	level_container.add_child(current_level_node)

	countdown.start_countdown()


func _physics_process(delta: float) -> void:
	if player_node.velocity.length() > 0:
		active_clock.start_counting()

func _ready() -> void:
	#creating clock
	active_clock = clock_scene.instantiate()
	active_clock.setup(70.0)
	add_child(active_clock)
