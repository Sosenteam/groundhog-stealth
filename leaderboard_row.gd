extends HBoxContainer

@onready var rank_lbl = $RankLabel
@onready var name_lbl = $NameLabel
@onready var coin_lbl = $CoinLabel
@onready var date_lbl = $MarginContainer/DateLabel

func setup(rank: int, username: String, coins: int, date: String = "") -> void:
	rank_lbl.text = "#" + str(rank)
	name_lbl.text = username
	coin_lbl.text = str(coins)
	
	if date_lbl:
		date_lbl.text = date
	else:
		date_lbl.text = ""
