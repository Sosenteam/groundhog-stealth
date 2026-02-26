extends Node2D

@export var coinPrefab:PackedScene;
@export var coinCollisionLayer:int = 3;
@export var coinZIndex:int = 20;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#newCoin()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func newCoin():
	var coinInstance:Area2D = coinPrefab.instantiate();
	add_child(coinInstance);
	
	coinInstance.z_index = coinZIndex
	coinInstance.collision_layer = 0;
	coinInstance.set_collision_mask_value(coinCollisionLayer, true)	
