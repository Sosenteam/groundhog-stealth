extends CanvasLayer

@onready var label: Label = $Label

func update_coins(count: int) -> void:
	label.text = "Coins: " + str(count)
