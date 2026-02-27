extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Timer.start()
	$CanvasLayer/AnimationPlayer.play("winpopup")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$CanvasLayer/Calender/AnimationPlayer.play("CalenderFlipping")
