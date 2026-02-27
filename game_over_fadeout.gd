extends CanvasLayer

@export var redfadeTime:float = 1.5;
@export var blackfadeTime:float = 2;

func _ready() -> void:
	$redout.modulate.a = 0;
	
	var redtween = create_tween()
	redtween.tween_property($redout, "modulate:a", 1, redfadeTime).set_trans(Tween.TRANS_LINEAR)
	
	await redtween.finished
	
	var blacktween = create_tween()
	blacktween.tween_property($redout, "modulate", Color.BLACK, blackfadeTime).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC);
	
	await blacktween.finished
	
	print("Gop")
