extends Node

onready var board = $Board
var players: Array = []
var currentPlayer
var laps = 1


func _ready():
	create_players()
	board.adjust_tokens(board.get_cell_at(0))
	start_game()


func create_players():
	players.append(create_player())
	players.append(create_player())
	#players.append(create_player())
	#players.append(create_player())


func create_player():
	var player = load("res://scripts/Player.gd").new()
	var cell = board.get_cell_at(0)
	cell.add_player(player)
	player.set_cell(cell)
	var avatars = ["chick", "chicken", "owl", "parrot"]
	var avatar = avatars[randi() % avatars.size()]
	var token = board.create_token(player, avatar)
	var bag = cell.get_bag(player)
	token.set_position(bag.position)
	return player


func start_game():
	currentPlayer = players[0]
	start_turn()


func start_turn():
	yield(move_player(currentPlayer, 20), "completed")
	end_turn()


func move_player(player, steps):
	var token = board.get_token(player)
	var cell = player.get_cell()
	cell.remove_player(player)
	player.set_cell(null)
	var bag: Rect2
	var passing = true
	for i in range(steps):
		cell = cell.get_next_cell()
		bag = cell.get_middle_bag()
		if cell.get_index() == 0:
			if player.lap == laps:
				player.set_finished(true)
				passing = false
			else:
				player.lap += 1
		passing = passing && i < steps - 1
		if !passing:
			cell.add_player(player)
			player.set_cell(cell)
			bag = cell.get_bag(player)
			board.adjust_tokens(cell)
		yield(token.move_to(bag.position), "finished")
		if !passing:
			break


func end_turn():
	var index = players.find(currentPlayer, 0)
	index = (index + 1) % players.size()
	var player = players[index]
	while player.is_finished() && player != currentPlayer:
		index = (index + 1) % players.size()
		player = players[index]
	if player == currentPlayer && player.is_finished():
		end_game()
	else:
		currentPlayer = player
		start_turn()


func end_game():
	print("end game")
