extends "res://components/cards/Card.gd"


func play(player):
	yield(get_tree(), "idle_frame")
	player.get_cards().erase(self)
	game.card_removed(player, self)
