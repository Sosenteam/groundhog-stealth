class_name Player extends CharacterBody2D

@export var speed = 400
@export var dash_time = 0.25
@export var dash_cooldown = 1
@export var dash_mult = 6

@export var coinCount:int = 0
signal coins_changed(count: int)

var input_dir = Vector2.ZERO

var player_sprite: Sprite2D
var tex_up = preload("res://assets/player/up.png")
var tex_down = preload("res://assets/player/down.png")
var tex_side = preload("res://assets/player/side.png")
var tex_sidedown = preload("res://assets/player/sidedown.png")

func _ready() -> void:
	$"DashCooldown/DashActive".wait_time = dash_time
	$"DashCooldown".wait_time = dash_cooldown
	$DashCooldown/DashActive.connect("timeout",dash_active_callback)
	
	player_sprite = Sprite2D.new()
	player_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	player_sprite.texture = tex_down
	add_child(player_sprite)
	
	$AnimatedSprite2D.visible = false

func _physics_process(delta: float) -> void:
	velocity = input_dir * speed
	if(!$DashCooldown/DashActive.is_stopped()):
		velocity*=dash_mult
	move_and_slide()

func _process(delta: float) -> void:
	#sprite direction
	if input_dir.length() > 0:
		var deg = rad_to_deg(input_dir.angle())
		
		if deg >= -22.5 and deg <= 22.5:
			player_sprite.texture = tex_side
			player_sprite.flip_h = false
		elif deg > 22.5 and deg < 67.5:
			player_sprite.texture = tex_sidedown
			player_sprite.flip_h = false
		elif deg >= 67.5 and deg <= 112.5:
			player_sprite.texture = tex_down
			player_sprite.flip_h = false
		elif deg > 112.5 and deg < 157.5:
			player_sprite.texture = tex_sidedown
			player_sprite.flip_h = true
		elif deg >= 157.5 or deg <= -157.5:
			player_sprite.texture = tex_side
			player_sprite.flip_h = true
		else:
			player_sprite.texture = tex_up
			player_sprite.flip_h = false
	

func _input(event: InputEvent) -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(event.is_action_pressed("move_dash") && 
	$"DashCooldown".is_stopped() && 
	$"DashCooldown/DashActive".is_stopped()):
		$DashCooldown/DashActive.start()

func dash_active_callback():
	$DashCooldown.start()
	
func addCoin(value:int):
	coinCount += value;
	coins_changed.emit(coinCount)
