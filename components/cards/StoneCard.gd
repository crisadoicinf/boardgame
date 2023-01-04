extends "res://components/cards/Card.gd"


func play(player):
	player.get_cards().erase(self)
	game.card_removed(player, self)
	var players = _get_players(player)
	var token = game.get_board().create_token(self, "res://resources/items/" + get_id() + ".png")
	token.set_position(player.get_cell().get_bag(player).position)

	#player needs to target another player
	var target = players[randi() % players.size()]
	yield(move_token(player, token, target), "completed")
	print("hit")


func _get_players(player):
	var cellBehind
	var db = game.get_board().get_cells_length()
	var cellAhead
	var da = game.get_board().get_cells_length()
	var d
	for p in game.get_players():
		d = player.get_cell().get_distance_behind(p.get_cell())
		if d < db and d > 0:
			db = d
			cellBehind = p.get_cell()
		d = player.get_cell().get_distance_ahead(p.get_cell())
		if d < da and d > 0:
			da = d
			cellAhead = p.get_cell()
	var players = []
	players.append_array(cellBehind.get_players())
	players.append_array(player.get_cell().get_players())
	players.append_array(cellAhead.get_players())
	players.erase(player)
	var unique = []
	for item in players:
		if not unique.has(item):
			unique.append(item)
	return unique
