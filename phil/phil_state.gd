class_name PhilState extends State

const IDLE = "Idle"
const BURROWING = "Burrowing"
const SEARCHING = "Searching"
const EMERGING = "Emerging"

var phil: Phil


func _ready() -> void:
	await owner.ready
	phil = owner as Phil
	assert(phil != null, "ThePhilState needs to be in a phil scene")
