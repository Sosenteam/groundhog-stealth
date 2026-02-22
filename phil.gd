extends CharacterBody2D

@export var view_length = 100

var direction = Vector2(1,0)
var rays_to_draw = []

func _ready() -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	rays_to_draw = []
	var original_angle = direction.angle()
	for i in range(-4,4):
		var angle = remap(i,-4,4,-PI/6,PI/6)
		var new_direction = Vector2.from_angle(original_angle+angle)
		raycast(new_direction*view_length)
	queue_redraw()

func _draw() -> void:
	for ray in rays_to_draw:
		draw_line(ray[0],ray[1],Color.GREEN,1)

func raycast(vect: Vector2):
	var space_state = get_world_2d().direct_space_state
	#global coords
	var query = PhysicsRayQueryParameters2D.create(position, position+vect)
	var result = space_state.intersect_ray(query)
	
	var raycast_points = [position, position+vect]
	rays_to_draw.push_back(raycast_points)
	return result
