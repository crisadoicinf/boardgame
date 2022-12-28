extends Object

const HitPlayerNearbyCard = preload("res://scripts/cards/HitPlayerNearbyCard.gd")
const HitPlayerWithDiceCard = preload("res://scripts/cards/HitPlayerWithDiceCard.gd")

const cards = [HitPlayerNearbyCard, HitPlayerWithDiceCard]


func _init():
	randomize()


func draw_card():
	return cards[randi() % cards.size()].new()
