extends Node2D

@onready var player_node = $Player
const clock_scene = preload("res://clock.tscn")
var active_clock: Node
func _physics_process(delta: float) -> void:
	if player_node.velocity.length() > 0:
		active_clock.start_counting()

func _ready() -> void:
	
	#creating clock
	active_clock = clock_scene.instantiate()
	active_clock.setup(70.0)
	add_child(active_clock) 
	
	

	
