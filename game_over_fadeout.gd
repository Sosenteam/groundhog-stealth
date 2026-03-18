extends CanvasLayer

@export var redfadeTime:float = 1.5;
@export var blackfadeTime:float = 2;

func _ready() -> void:
	$restart.hide()
	$redout.modulate.a = 0;
	
	var redtween = create_tween()
	redtween.tween_property($redout, "modulate:a", 1, redfadeTime).set_trans(Tween.TRANS_LINEAR)
	
	await redtween.finished
	get_tree().paused = true
	
	var blacktween = create_tween()
	blacktween.tween_property($redout, "modulate", Color.BLACK, blackfadeTime).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC);
	
	await blacktween.finished
	
	$restart.show();


func _on_restart_pressed() -> void:
	get_tree().paused = false;
	get_tree().reload_current_scene()
