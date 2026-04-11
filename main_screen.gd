extends Control

const next_scene = preload("res://arcade_keyboard.tscn")
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
	load_leaderboard()

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(next_scene)

func _on_quit_button_pressed() -> void:
	get_tree().quit()



func load_leaderboard() -> void:
	var file = FileAccess.open("user://scores.json", FileAccess.READ)
	if file:
		var scores = JSON.parse_string(file.get_as_text())
		if typeof(scores) == TYPE_ARRAY:
			var n = 1
			for score in scores:
				var row = LEADERBOARD_ROW.instantiate()
				leaderboard_vbox.add_child(row)
				row.setup(n, str(score.user), int(score.coins))
				n += 1
		file.close()

func _toggle_leaderboard() -> void:
	leaderboard_open = !leaderboard_open
	var t = create_tween()
	t.tween_property(leaderboard_panel, "position:x", 0.0 if leaderboard_open else -400.0, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and start_button.has_focus():
		_on_start_button_pressed()
