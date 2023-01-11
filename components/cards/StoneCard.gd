extends "res://components/cards/Card.gd"


func play(player):
	player.get_cards().erase(self)
	game.card_removed(player, self)
	var token = game.get_board().create_token(self, get_id())
	token.set_position(game.get_board().get_token(player).get_position())
	var target = yield(game.target_player(_get_players(player)), "completed")
	yield(move_token_to_target(player, token, target), "completed")
	game.get_board().remove_token(token)
	game.hit_player(player, target)


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
