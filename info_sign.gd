extends Area2D
class_name InfoSign

@export var title: String = ""
@export_multiline var description: String = ""

signal player_entered_sign(title: String, description: String)
signal player_exited_sign

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	connect("body_exited", _on_body_exited)

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		player_entered_sign.emit(title, description)

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		player_exited_sign.emit()
