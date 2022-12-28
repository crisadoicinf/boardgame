extends Node2D

const Deck = preload("res://scripts/cards/Deck.gd")
const Player = preload("res://scripts/Player.gd")

onready var board = $Board
onready var dice = $Dice
onready var playerSlots = [
	$PlayerSlots/Slot1, $PlayerSlots/Slot2, $PlayerSlots/Slot3, $PlayerSlots/Slot4
]
onready var playerMainCard = $PlayerMainCard
var players: Array = []
var currentPlayer
var laps = 1
var movingPlayer: bool = false
var avatars = []
var deck = Deck.new()


func _ready():
	randomize()
	board.set_game(self)
	create_players(4)
	for player in players:
		var cell = board.get_cell_at(0)
		cell.add_player(player)
		player.set_cell(cell)
		var bag = cell.get_bag(player)
		var token = board.create_token(player, player.get_avatar())
		token.set_position(bag.position)
		playerSlots[player.get_slot()].set_player(player)
	board.adjust_tokens(board.get_cell_at(0))
	start_game()


func create_players(total: int):
	avatars = ["chick", "chicken", "owl", "parrot", "penguin"].duplicate()
	avatars.shuffle()
	var slot = randi() % playerSlots.size()
	for _i in range(total):
		var player = Player.new()
		player.set_avatar(avatars.pop_back())
		player.set_slot(slot % playerSlots.size())
		slot += 1
		players.append(player)


func get_deck():
	return deck


func get_player_main_card():
	return playerMainCard


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
		#check if cell is goal
		if cell.get_index() == 0:
			#it is last player's lap
			if player.lap == laps:
				player.set_finished(true)
				passing = false
			#player starts next lap
			else:
				player.lap += 1
		#check if it is the last step
		passing = passing and i < steps - 1
		if passing:
			bag = cell.get_middle_bag()
		else:
			cell.add_player(player)
			player.set_cell(cell)
			bag = cell.get_bag(player)
			board.adjust_tokens(cell)
		yield(token.move_to(bag.position), "completed")
		#check if player should stop moving
		if !passing:
			break
	yield(player.get_cell().on_player_step(player), "completed")
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
			handle_dice_click()


func handle_dice_click():
	if !dice.is_rolling() and !movingPlayer:
		var number = dice.get_random_number()
		number = 4
		playerSlots[currentPlayer.slot].roll_dice(number)
		yield(dice.roll(number), "completed")
		yield(move_player(currentPlayer, number), "completed")
		end_turn()
