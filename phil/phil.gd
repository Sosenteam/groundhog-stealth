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

@onready var arrow_pivot = $ArrowPivot
@onready var indicator_arrow = $ArrowPivot/IndicatorArrow

func _ready() -> void:
	pass
	
	
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

	
