extends CanvasLayer

signal countdown_finished

@onready var label = $Label
@onready var timer = $Timer

var count = 3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.wait_time = 1.0
	timer.timeout.connect(_on_timer_timeout)
	update_display()
	
func start_countdown():
	show()
	update_display()
	timer.start()

func update_display():
	if count > 0:
		label.text = str(count)
	else:
		label.text = "GO!"

func _on_timer_timeout():
	count -= 1
	update_display()

	if count < -1:
		emit_signal("countdown_finished")
		queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
