extends Control

signal win_finished

@export var kill_me = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/Timer.start()
	$CanvasLayer/Timer2.start()
	$CanvasLayer/AnimationPlayer.play("winpopup")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$CanvasLayer/Calender/AnimationPlayer.play("CalenderFlipping")


func _on_timer_2_timeout() -> void:
	var tween = create_tween().set_parallel(true)
	tween.tween_property($CanvasLayer/Popup, "modulate:a", 0, 1.0)
	tween.tween_property($CanvasLayer/Calender, "modulate:a", 0, 1.0)
	
	await tween.finished
	kill_me = true
	win_finished.emit()

func get_kill_me():
	print("asdfghjkiuhgyfetdghbjnkOAFHUBD NJA")
	return kill_me
