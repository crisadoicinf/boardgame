extends "res://scripts/board/BoardCell.gd"


func on_player_step(player):
	yield(get_tree(), "idle_frame")
	var card = game.get_deck().draw_card()
	player.get_cards().append(card)
	game.get_player_main_card().set_card(card)
	print("give player '", player.get_avatar(), "' card '", card.get_item_id(), "'")
