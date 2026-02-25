extends Node2D

@onready var time_label = $CanvasLayer/TimeLabel
@onready var innerclock = $CanvasLayer/Outerclock/Innerclock
@onready var night_effect_panel = $CanvasLayer/NightEffect
var time_left = 60.0
var counting_down = false
var total_time = time_left
const night_effect_opacity_limit_percent = 0.6


#instantiate how long the time goes for - default 60 seconds
func setup(time) -> void:
	time_left = time
	total_time = time

#starts the count down - by default, does not count down
func start_counting():
	counting_down = true
	
func stop_counting():
	counting_down = false
	
func set_time_label():
	var minutes = int(time_left) / 60
	var seconds = int(time_left) % 60
	var formatted_time = "%01d:%02d" % [minutes, seconds]
	time_label.text = formatted_time
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	set_time_label()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	innerclock.rotation_degrees = (time_left/total_time)*360
	#print(time_left)
	if (counting_down):
		if time_left > 0.0:
			time_left -= delta
			determine_alpha()
			set_time_label()
		else:
			print(" seconds passed")
			set_process(false) # Stops the process
			
#this determines what level of darkness (the opacity of the night effect panel) there is. It's really janky, pelase fix if you are willing or hate it enought to do so (:
func determine_alpha():
	var alpha = 0;
	var stylebox: StyleBoxFlat = night_effect_panel.get_theme_stylebox("panel").duplicate()
	if (time_left/total_time < 0.2): #this is near end of day
		alpha = 0
	elif (time_left/total_time < 0.3):
		alpha = 0.2
	elif (time_left/total_time < 0.7):
		alpha = 0.4
	
	elif (time_left/total_time < 0.8):
		alpha = 0.2
		
	elif (time_left/total_time < 1): #this is start of day
		alpha = 0
		
		
		
	stylebox.bg_color = Color(0.0, 0.0, 0.0, alpha)
	night_effect_panel.add_theme_stylebox_override("panel", stylebox)
