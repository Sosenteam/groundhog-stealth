extends CanvasLayer

@export var redfadeTime:float = 1.5;
@export var blackfadeTime:float = 2;

var main_menu_btn: Button

func _ready() -> void:
	$restart.hide()
	$redout.modulate.a = 0;
	
	main_menu_btn = Button.new()
	main_menu_btn.text = "Main Menu"
	main_menu_btn.theme = $restart.theme
	main_menu_btn.add_theme_color_override("font_color", Color.WHITE)
	main_menu_btn.size = $restart.size
	main_menu_btn.position = $restart.position + Vector2(0, $restart.size.y + 20)
	main_menu_btn.pressed.connect(_on_main_menu_pressed)
	main_menu_btn.hide()
	add_child(main_menu_btn)
	
	var style = StyleBoxFlat.new()
	style.bg_color = Color(0.15, 0.15, 0.15, 0.9)
	style.corner_radius_top_left = 8
	style.corner_radius_top_right = 8
	style.corner_radius_bottom_right = 8
	style.corner_radius_bottom_left = 8
	style.border_width_left = 2
	style.border_width_top = 2
	style.border_width_right = 2
	style.border_width_bottom = 2
	style.border_color = Color(0.4, 0.4, 0.4, 0.8)
	
	var hover = style.duplicate()
	hover.bg_color = Color(0.25, 0.25, 0.25, 1.0)
	
	$restart.add_theme_stylebox_override("normal", style)
	$restart.add_theme_stylebox_override("hover", hover)
	main_menu_btn.add_theme_stylebox_override("normal", style)
	main_menu_btn.add_theme_stylebox_override("hover", hover)
	
	var redtween = create_tween()
	redtween.tween_property($redout, "modulate:a", 1, redfadeTime).set_trans(Tween.TRANS_LINEAR)
	
	await redtween.finished
	get_tree().paused = true
	
	var blacktween = create_tween()
	blacktween.tween_property($redout, "modulate", Color.BLACK, blackfadeTime).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC);
	
	await blacktween.finished
	
	$restart.show();
	main_menu_btn.show()


func _on_restart_pressed() -> void:
	get_tree().paused = false;
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_screen.tscn")
