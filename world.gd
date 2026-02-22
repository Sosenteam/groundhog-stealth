extends Node2D


func _physics_process(delta: float) -> void:
	$Phil.direction = ($Player.position -$Phil.position).normalized()
