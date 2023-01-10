extends Node2D

const StickCard = preload("res://components/cards/StickCard.tscn")
const StoneCard = preload("res://components/cards/StoneCard.tscn")

const cards = [StickCard, StoneCard]
onready var firstCard: Sprite = $FirstCard


func _init():
	randomize()


func get_size() -> Vector2:
	return (firstCard.get_position() + firstCard.texture.get_size()) * firstCard.get_scale()


func draw_card():
	return cards[randi() % cards.size()].instance()
