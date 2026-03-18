extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Bush.rotation_degrees = randi_range(-180,180)
	var i = randi() % 2
	if (i == 1):
		$Berries.rotation_degrees = randi_range(-180,180)
	else:
		$Berries.hide()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
