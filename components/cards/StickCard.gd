extends "res://components/cards/Card.gd"


func play(player):
	player.get_cards().erase(self)
	game.card_removed(player, self)
