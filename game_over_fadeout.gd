extends CanvasLayer

@export var redfadeTime:float = 1.5;
@export var blackfadeTime:float = 2;

var main_menu_btn: Button

func _ready() -> void:
	get_tree().paused = true
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
	
	# White outline focus style for controller navigation
	var focus_style = StyleBoxFlat.new()
	focus_style.draw_center = false
	focus_style.border_width_left = 3
	focus_style.border_width_top = 3
	focus_style.border_width_right = 3
	focus_style.border_width_bottom = 3
	focus_style.border_color = Color.WHITE
	focus_style.corner_radius_top_left = 8
	focus_style.corner_radius_top_right = 8
	focus_style.corner_radius_bottom_right = 8
	focus_style.corner_radius_bottom_left = 8
	focus_style.expand_margin_left = 4.0
	focus_style.expand_margin_top = 4.0
	focus_style.expand_margin_right = 4.0
	focus_style.expand_margin_bottom = 4.0
	$restart.add_theme_stylebox_override("focus", focus_style)
	main_menu_btn.add_theme_stylebox_override("focus", focus_style.duplicate())
	
	# Set up focus neighbors so d-pad navigates between buttons
	$restart.focus_neighbor_bottom = main_menu_btn.get_path()
	main_menu_btn.focus_neighbor_top = $restart.get_path()
	
	var redtween = create_tween()
	redtween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	redtween.tween_property($redout, "modulate:a", 1, redfadeTime).set_trans(Tween.TRANS_LINEAR)
	
	await redtween.finished
	
	var blacktween = create_tween()
	blacktween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	blacktween.tween_property($redout, "modulate", Color.BLACK, blackfadeTime).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	await blacktween.finished
	
	$restart.show();
	main_menu_btn.show()
	$restart.grab_focus()


func _on_restart_pressed() -> void:
	get_tree().paused = false;
	get_tree().reload_current_scene()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("gamepad_start"):
		_on_restart_pressed()
	if event.is_action_pressed("gamepad_back"):
		_on_main_menu_pressed()
		

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main_screen.tscn")
