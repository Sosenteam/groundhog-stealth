extends Node2D

var angle = 0

func _physics_process(delta: float) -> void:
	$Phil.direction = Vector2.from_angle(angle)
	angle+= 0.01
