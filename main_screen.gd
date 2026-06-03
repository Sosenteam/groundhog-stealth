extends Control

var next_scene_path = "res://arcade_keyboard.tscn"
const LEADERBOARD_ROW = preload("res://leaderboard_row.tscn")

@onready var title_label: Label = $CanvasLayer/CenterContainer/VBox/TitleLabel
@onready var subtitle_label: Label = $CanvasLayer/CenterContainer/VBox/SubtitleLabel
@onready var start_button: Button = $CanvasLayer/CenterContainer/VBox/Buttons/StartButton
@onready var quit_button: Button = $CanvasLayer/CenterContainer/VBox/Buttons/QuitButton

@onready var leaderboard_panel: Panel = $CanvasLayer/LeaderboardPanel
@onready var leaderboard_vbox: VBoxContainer = $CanvasLayer/LeaderboardPanel/ScrollContainer/LeaderboardVBox
@onready var scores_button: Button = $CanvasLayer/LeaderboardPanel/ScoresButton

var leaderboard_open = false

func _ready() -> void:
	$CanvasLayer/CenterContainer.modulate.a = 1.0
	start_button.grab_focus()
	scores_button.pressed.connect(_toggle_leaderboard)
	
	# Fix controller navigation to Scores button
	start_button.focus_neighbor_right = scores_button.get_path()
	quit_button.focus_neighbor_right = scores_button.get_path()
	scores_button.focus_neighbor_left = start_button.get_path()
	
	$CanvasLayer/MusicInfoContainer/MusicInfoButton.focus_entered.connect(func(): $CanvasLayer/MusicInfoContainer/MusicInfoButton.modulate = Color(1.5, 1.5, 1.5))
	$CanvasLayer/MusicInfoContainer/MusicInfoButton.focus_exited.connect(func(): $CanvasLayer/MusicInfoContainer/MusicInfoButton.modulate = Color.WHITE)
	$CanvasLayer/MusicInfoContainer/MusicInfoButton.mouse_entered.connect(func(): $CanvasLayer/MusicInfoContainer/MusicInfoButton.modulate = Color(1.5, 1.5, 1.5))
	$CanvasLayer/MusicInfoContainer/MusicInfoButton.mouse_exited.connect(func(): $CanvasLayer/MusicInfoContainer/MusicInfoButton.modulate = Color.WHITE)
	
	ResourceLoader.load_threaded_request(next_scene_path)
	ResourceLoader.load_threaded_request("res://CliffordGibson.tscn")
	
	load_leaderboard()

func _on_start_button_pressed() -> void:
	var res = ResourceLoader.load_threaded_get(next_scene_path)
	if res:
		get_tree().change_scene_to_packed(res)
	else:
		get_tree().change_scene_to_file(next_scene_path)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_music_info_button_pressed() -> void:
	var res = ResourceLoader.load_threaded_get("res://CliffordGibson.tscn")
	if res:
		get_tree().change_scene_to_packed(res)
	else:
		get_tree().change_scene_to_file("res://CliffordGibson.tscn")



func load_leaderboard() -> void:
	var file = FileAccess.open("user://scores.json", FileAccess.READ)
	if file:
		var scores = JSON.parse_string(file.get_as_text())
		if typeof(scores) == TYPE_ARRAY:
			var n = 1
			for score in scores:
				if n > 100:
					break
				var row = LEADERBOARD_ROW.instantiate()
				leaderboard_vbox.add_child(row)
				var d_string = ""
				if score.has("date"):
					d_string = str(score.date)
				row.setup(n, str(score.user), int(score.coins), d_string)
				n += 1
				if n % 10 == 0:
					await get_tree().process_frame
		file.close()

func _toggle_leaderboard() -> void:
	leaderboard_open = !leaderboard_open
	var t = create_tween()
	t.tween_property(leaderboard_panel, "position:x", 0.0 if leaderboard_open else -400.0, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("gamepad_start"):
		_on_start_button_pressed()
	if event.is_action_pressed("gamepad_back"):
		if leaderboard_open:
			_toggle_leaderboard()
		else:
			_on_quit_button_pressed()
