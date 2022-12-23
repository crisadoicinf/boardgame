extends Node

onready var board = $Board
var players: Array = []
var playerIndex = 0


func _ready():
	create_players()
	board.adjust_tokens(board.get_cell_at(0))
	start_game()


func create_players():
	players.append(create_player())
	players.append(create_player())
	players.append(create_player())
	players.append(create_player())


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


func get_current_player():
	return players[playerIndex]


func start_game():
	start_turn()


func start_turn():
	var player = get_current_player()
	yield(move_player(player, 5), "completed")
	end_turn()


func move_player(player, steps):
	var token = board.get_token(player)
	var cell = player.get_cell()
	cell.remove_player(player)
	player.set_cell(null)
	var bag: Rect2
	for i in range(steps):
		cell = cell.get_next_cell()
		bag = cell.get_middle_bag()
		if i == 4:
			cell.add_player(player)
			player.set_cell(cell)
			bag = cell.get_bag(player)
		board.adjust_tokens(cell)
		yield(token.move_to(bag.position), "finished")


func end_turn():
	playerIndex = (playerIndex + 1) % players.size()
	start_turn()
