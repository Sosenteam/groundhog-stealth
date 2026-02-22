extends CharacterBody2D

@export var speed = 400
@export var dash_time = 0.25
@export var dash_cooldown = 1
@export var dash_mult = 6

var input_dir = Vector2.ZERO

func _ready() -> void:
	$"DashCooldown/DashActive".wait_time = dash_time
	$"DashCooldown".wait_time = dash_cooldown
	$DashCooldown/DashActive.connect("timeout",dash_active_callback)

func _physics_process(delta: float) -> void:
	velocity = input_dir * speed
	if(!$DashCooldown/DashActive.is_stopped()):
		velocity*=dash_mult
	move_and_slide()

func _process(delta: float) -> void:
	#flip sprite
	if(input_dir.x<0):
		$AnimatedSprite2D.flip_h = true
	elif(input_dir.x>0):
		$AnimatedSprite2D.flip_h = false

	
	#animations
	if(!$DashCooldown/DashActive.is_stopped()):
		$AnimatedSprite2D.play("dashing")
	elif(is_equal_approx(input_dir.length(),0)):
		$AnimatedSprite2D.play("idle")
	elif(input_dir.length()>0):
		$AnimatedSprite2D.play("walking")
	

func _input(event: InputEvent) -> void:
	input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if(event.is_action_pressed("move_dash") && 
	$"DashCooldown".is_stopped() && 
	$"DashCooldown/DashActive".is_stopped()):
		$DashCooldown/DashActive.start()

func dash_active_callback():
	$DashCooldown.start()
	
