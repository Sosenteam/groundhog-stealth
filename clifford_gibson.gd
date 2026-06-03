extends Node2D

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("gamepad_back") or Input.is_physical_key_pressed(KEY_B):
		get_tree().change_scene_to_file("res://main_screen.tscn")
