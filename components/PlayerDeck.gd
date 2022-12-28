extends Node2D

signal click_player_card(playerCard)

const PlayerCard = preload("res://components/PlayerCard.tscn")
onready var anim: AnimationPlayer = $Anim
onready var playerCards: Node2D = $PlayerCards
var enabled: bool = true


func set_cards(cards: Array):
	var total = max(playerCards.get_children().size(), cards.size())
	var playerCard
	var y = 0
	var padding = 5
	for i in range(total):
		if i >= playerCards.get_children().size():
			playerCard = PlayerCard.instance()
			playerCard.connect("click", self, "_on_player_card_click")
			playerCards.add_child(playerCard)
		playerCard = playerCards.get_child(i)
		if i >= cards.size():
			playerCard.set_card(null)
			playerCard.set_visible(false)
		else:
			playerCard.set_card(cards[i])
			playerCard.set_visible(true)
			y -= playerCard.get_size().y + padding
			playerCard.set_position(Vector2(0, y))


func hide():
	anim.play("hide")


func show():
	anim.play("show")


func set_enabled(value: bool):
	enabled = value


func _on_player_card_click(playerCard):
	if enabled:
		emit_signal("click_player_card", playerCard)
