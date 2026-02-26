extends Control
signal detected

@export_group("detection settings")
@export var maxSeenTime:float;
@export var decayRate:float;
@export var decayDelay:float = 0.2;

var vignetteMaxAlpha:float = 0.5;
var vignetteStartPercent:float = 0.5;
var ringMaxAlpha = 0.447058824;

@export var canPhilSeePlayer:bool = false;
var currentSeenTime:float;
var timeAfterStoppedBeingSeen:float;

func setCanPhilSeePlayer(newCanSee:bool):
	canPhilSeePlayer = newCanSee
	
func setSettings(maxSeenTime:float, decayRate:float, decayDelay:float):
	self.maxSeenTime = maxSeenTime;
	self.decayRate = decayRate;
	self.decayDelay = decayDelay;

func _ready() -> void:
	vignetteMaxAlpha = $vignette.modulate.a;
	ringMaxAlpha = $center/squarecontainer/progressbar.modulate.a

func _process(delta: float) -> void:
	if canPhilSeePlayer:
		currentSeenTime += delta;
		timeAfterStoppedBeingSeen = 0;
	else:
		timeAfterStoppedBeingSeen += delta;
		if(timeAfterStoppedBeingSeen > decayDelay):
			currentSeenTime -= delta * decayRate;
		
	
	# prevent seen time from going negative
	currentSeenTime = clampf(currentSeenTime, 0.0, maxSeenTime);
	
	var detectionPercentage = clampf(currentSeenTime / maxSeenTime, 0.0, 1.0);
	var vignettePercentage = clampf((currentSeenTime - vignetteStartPercent) / (maxSeenTime - vignetteStartPercent), 0.0, 1.0);
	
	$vignette.modulate.a = sqrt(vignettePercentage) * vignetteMaxAlpha;
	
	$center/squarecontainer/progressbar.value = detectionPercentage;
	$center/squarecontainer/progressbar.modulate.a = sqrt(detectionPercentage) * ringMaxAlpha;
	
	$center/squarecontainer/progressbar/exclamation.modulate.a = clampf((detectionPercentage - 0.4) * 2, 0, 1)
	
	if(detectionPercentage >= 1.0):
		detected.emit();


func _on_phil_start_detecting() -> void:
	print(":3")
	setCanPhilSeePlayer(true)


func _on_phil_stop_detecting() -> void:
	print("3:")
	setCanPhilSeePlayer(false)
