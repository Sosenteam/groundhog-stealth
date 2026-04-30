extends Area2D
signal collected

var value:int = 1;

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.addCoin(value)
		collected.emit()
		queue_free()
