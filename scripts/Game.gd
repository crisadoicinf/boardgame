extends Node2D

onready var board = $Board
onready var dice = $Dice
var players: Array = []
var currentPlayer
var laps = 1
var movingPlayer: bool = false


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
	print("start_turn")


func move_player(player, steps):
	movingPlayer = true
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
		passing = passing and i < steps - 1
		if !passing:
			cell.add_player(player)
			player.set_cell(cell)
			bag = cell.get_bag(player)
			board.adjust_tokens(cell)
		yield(token.move_to(bag.position), "completed")
		if !passing:
			break
	movingPlayer = false


func end_turn():
	var index = players.find(currentPlayer, 0)
	index = (index + 1) % players.size()
	var player = players[index]
	while player.is_finished() and player != currentPlayer:
		index = (index + 1) % players.size()
		player = players[index]
	if player == currentPlayer and player.is_finished():
		end_game()
	else:
		currentPlayer = player
		start_turn()


func end_game():
	print("end game")


func get_child_rect(child) -> Rect2:
	return Rect2(child.get_position(), child.get_size() * child.get_scale())


func _input(event):
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.get_button_index() == BUTTON_LEFT
	):
		if get_child_rect(dice).has_point(to_local(event.position)):
			roll_dice()


func roll_dice():
	if !dice.is_rolling() and !movingPlayer:
		var number = dice.get_random_number()
		print("dice", " ", number)
		yield(dice.roll(number), "completed")
		yield(move_player(currentPlayer, number), "completed")
		end_turn()
