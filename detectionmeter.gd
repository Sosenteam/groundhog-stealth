extends Control

@export_group("detection settings")
@export var maxSeenTime:float;
@export var decayRate:float;

@export_group("vignette")
@export var vignetteMaxAlpha:float = 0.5;
@export var vignetteStartPercent:float = 0.5;


@export var canPhilSeePlayer:bool = false;
var currentSeenTime:float;
var vignetteColor:Color;

func setCanPhilSeePlayer(canSeePlayer:bool):
	self.canPhilSeePlayer = canPhilSeePlayer

func _ready() -> void:
	vignetteColor = $vignette.modulate;

func _process(delta: float) -> void:
	if canPhilSeePlayer:
		currentSeenTime += delta;
	else:
		currentSeenTime -= delta * decayRate
	
	# prevent seen time from going negative
	currentSeenTime = clampf(currentSeenTime, 0.0, maxSeenTime);
	
	var detectionPercentage = clampf(currentSeenTime / maxSeenTime, 0.0, 1.0);
	var vignettePercentage = clampf((currentSeenTime - vignetteStartPercent) / (maxSeenTime - vignetteStartPercent), 0.0, 1.0);
	
	vignetteColor.a = vignettePercentage * vignetteMaxAlpha;
	$vignette.modulate = vignetteColor;
	
	$center/squarecontainer/progressbar.value = detectionPercentage;
