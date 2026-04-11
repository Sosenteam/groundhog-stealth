extends Control

const world_scene = preload("res://world.tscn")
@onready var name_label = $CanvasLayer/BgRect/CenterContainer/VBox/NameDisplay
@onready var grid = $CanvasLayer/BgRect/CenterContainer/VBox/GridContainer

var current_name = ""
var max_length = 3

func _ready() -> void:
	# Add keyboard buttons programmatically
	var alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
	for char in alphabet:
		var btn = Button.new()
		btn.text = char
		btn.custom_minimum_size = Vector2(60, 60)
		btn.theme_type_variation = "KeyboardBtn"
		# Setup style
		btn.add_theme_font_size_override("font_size", 32)
		btn.pressed.connect(on_key_pressed.bind(char))
		grid.add_child(btn)
		
	var del_btn = Button.new()
	del_btn.text = "DEL"
	del_btn.custom_minimum_size = Vector2(100, 60)
	del_btn.add_theme_font_size_override("font_size", 28)
	del_btn.pressed.connect(on_key_pressed.bind("DEL"))
	grid.add_child(del_btn)
	
	var done_btn = Button.new()
	done_btn.text = "DONE"
	done_btn.custom_minimum_size = Vector2(100, 60)
	done_btn.add_theme_font_size_override("font_size", 28)
	done_btn.pressed.connect(on_key_pressed.bind("DONE"))
	grid.add_child(done_btn)

	update_display()
	
	await get_tree().process_frame
	if grid.get_child_count() > 0:
		grid.get_child(0).grab_focus()

func on_key_pressed(key: String) -> void:
	if key == "DEL":
		if current_name.length() > 0:
			current_name = current_name.substr(0, current_name.length() - 1)
	elif key == "DONE":
		finish_input()
	else:
		if current_name.length() < max_length:
			current_name += key
			if current_name.length() == max_length:
				# Auto-focus the DONE button
				for btn in grid.get_children():
					if btn.text == "DONE":
						btn.grab_focus()
						break
	update_display()

func update_display() -> void:
	var display_str = ""
	for i in range(max_length):
		if i < current_name.length():
			display_str += current_name[i] + " "
		else:
			display_str += "_ "
	name_label.text = display_str

func finish_input() -> void:
	get_tree().root.set_meta("username", current_name)
	get_tree().change_scene_to_packed(world_scene)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") or event.is_action_pressed("move_dash"):
		# Let them go back to main screen or delete
		on_key_pressed("DEL")
