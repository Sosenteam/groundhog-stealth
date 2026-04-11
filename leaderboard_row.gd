extends HBoxContainer

@onready var rank_lbl = $RankLabel
@onready var name_lbl = $NameLabel
@onready var coin_lbl = $CoinLabel

func setup(rank: int, username: String, coins: int) -> void:
	rank_lbl.text = "#" + str(rank)
	name_lbl.text = username
	coin_lbl.text = str(coins)
