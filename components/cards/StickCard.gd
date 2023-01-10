extends "res://components/cards/Card.gd"

const Dice = preload("res://components/Dice.gd")


func play(player):
	player.get_cards().erase(self)
	game.card_removed(player, self)
	var token = game.get_board().create_token(self, "res://resources/items/" + get_id() + ".png")
	token.set_position(game.get_board().get_token(player).get_position())
	player.add_dices(1)
	var dice = Dice.get_random_number()
	#dice = 4
	yield(game.roll_dice(player, dice), "completed")
	var targets = _get_players(player, dice)
	if targets.empty():
		game.get_board().remove_token(token)
	else:
		var target = targets[0]
		if targets.size() > 1:
			target = yield(game.target_player(targets), "completed")
		yield(move_token_to_target(player, token, target), "completed")
		game.get_board().remove_token(token)
		game.hit_player(player, target)


func _get_players(player, distance) -> Array:
	var players = []
	var cell = player.get_cell()
	for p in game.get_players():
		if (
			p != player and distance == cell.get_distance_behind(p.get_cell())
			or distance == cell.get_distance_ahead(p.get_cell())
		):
			players.append(p)
	return players
