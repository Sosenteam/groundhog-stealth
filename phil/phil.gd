class_name Phil extends CharacterBody2D

@export var view_length = 100
@export var view_angle = PI/6
@export var speed = 50
@export var ray_count = 50

signal start_detecting
signal stop_detecting

var was_detecting:bool = false
var direction = Vector2(1,0)
var rays_to_draw = []
var debug_color = Color.GREEN
var view_cone_enabled = false
var recent_states = []

@onready var arrow_pivot = $ArrowPivot
@onready var indicator_arrow = $ArrowPivot/IndicatorArrow
var player_ref

var phil_sprite: Sprite2D
var dirt_sprite: Sprite2D

var tex_up = preload("res://assets/phil (temporary)/up.png")
var tex_down = preload("res://assets/phil (temporary)/down.png")
var tex_side = preload("res://assets/phil (temporary)/side.png")
var tex_sidedown = preload("res://assets/phil (temporary)/sidedown.png")
var tex_dirt = preload("res://assets/phil (temporary)/popupdirt.png")
var tex_underground = preload("res://assets/phil (temporary)/underground.png")

func _ready() -> void:
	if(get_parent().has_node("Player")):
		player_ref = $"../Player"
		
	phil_sprite = Sprite2D.new()
	phil_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	phil_sprite.z_index = 1
	add_child(phil_sprite)
	
	dirt_sprite = Sprite2D.new()
	dirt_sprite.texture = tex_dirt
	dirt_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	dirt_sprite.z_index = 2
	add_child(dirt_sprite)
	
	$AnimatedSprite2D.visible = false
	
	
func _physics_process(delta: float) -> void:
	# if viewcone is on, spread raycasts, and interpret result
	if(view_cone_enabled):
		var collision_result = check_for_collision()
		if(collision_result):
			debug_color = Color.RED
			if(!was_detecting):
				start_detecting.emit()
			was_detecting = true
		else:
			debug_color = Color.GREEN
			if(was_detecting):
				stop_detecting.emit()
			was_detecting = false
	# Redraw detection meter
	queue_redraw()
	update_sprites()

func update_sprites() -> void:
	if $AnimatedSprite2D.animation == "burrowing":
		phil_sprite.texture = tex_underground
		dirt_sprite.visible = false
		phil_sprite.flip_h = false
		return
		
	dirt_sprite.visible = true
	
	var deg = rad_to_deg(direction.angle())
	
	if deg >= -22.5 and deg <= 22.5:
		phil_sprite.texture = tex_side
		phil_sprite.flip_h = false
	elif deg > 22.5 and deg < 67.5:
		phil_sprite.texture = tex_sidedown
		phil_sprite.flip_h = false
	elif deg >= 67.5 and deg <= 112.5:
		phil_sprite.texture = tex_down
		phil_sprite.flip_h = false
	elif deg > 112.5 and deg < 157.5:
		phil_sprite.texture = tex_sidedown
		phil_sprite.flip_h = true
	elif deg >= 157.5 or deg <= -157.5:
		phil_sprite.texture = tex_side
		phil_sprite.flip_h = true
	else:
		phil_sprite.texture = tex_up
		phil_sprite.flip_h = false

func _draw() -> void:
	# Draw View Cone
	if(view_cone_enabled):
		# Make array of points for detection polygon
		var poly_array: PackedVector2Array = [Vector2(0,0)]
		var color_array: PackedColorArray = [debug_color]
		for ray in rays_to_draw:
			#draw_line(to_local(ray[0]),to_local(ray[1]),debug_color,1)
			poly_array.append(to_local(ray[1]))
			color_array.append(debug_color)
		draw_polygon(poly_array,color_array)
## Sents out raycasts across -view_angle to x
func check_for_collision() -> bool:
	var collision_result = false
	rays_to_draw = []
	var original_angle = direction.angle()
	for i in range(-ray_count/2,ray_count/2):
		var angle = remap(i,-ray_count/2,ray_count/2,-view_angle,view_angle)
		var new_direction = Vector2.from_angle(original_angle+angle)
		var result = raycast(new_direction*view_length)
		if(result):
			collision_result = true
	return collision_result
	
 
	
## Sends out raycasts in direction from phil.position 
func raycast(vect: Vector2):
	var is_colliding = false
	var space_state = get_world_2d().direct_space_state
	#global coords
	var query = PhysicsRayQueryParameters2D.create(position, position+vect)
	var result = space_state.intersect_ray(query)
	var final_point: Vector2 = position+vect
	if(result):
		if(result.collider.get_collision_layer_value(2)):
			is_colliding = true
		if(result.collider.get_collision_layer_value(1)):
			final_point = result.position
		#if(result.collider.collision_layer == 2 || result.collider.collision_layer == 1)

	
	var raycast_points = [position, final_point]
	rays_to_draw.push_back(raycast_points)
	return is_colliding

	
