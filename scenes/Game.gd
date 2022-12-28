extends Node2D

signal card_accepted

const Player = preload("res://components/Player.gd")

onready var board = $Board
onready var dice = $Dice
onready var playerSlots = [
	$PlayerSlots/Slot1, $PlayerSlots/Slot2, $PlayerSlots/Slot3, $PlayerSlots/Slot4
]
onready var deck = $Deck
onready var card = $Card
onready var playerMainCard = $PlayerMainCard
var players: Array = []
var currentPlayer
var laps = 1
var avatars = []


func _ready():
	randomize()
	board.set_game(self)
	place_deck()
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


func place_deck():
	var rect = board.get_deck_rect()
	var position = board.get_position() + rect.position * board.get_scale()
	var size = rect.size * board.get_scale()
	var rotation = 0
	if size.x > size.y:
		size = Vector2(size.y, size.x)
		position.y += size.x
		rotation = -90
	deck.set_position(position)
	deck.set_scale(size / deck.get_size())
	deck.set_rotation_degrees(rotation)


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


func start_game():
	currentPlayer = players[0]
	start_turn()


func start_turn():
	dice.set_enabled(true)
	print(currentPlayer.get_avatar(), " start_turn")


func move_player(player, steps):
	dice.set_enabled(false)
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
	dice.set_enabled(true)


func draw_card(player):
	dice.set_enabled(false)
	var size = deck.get_size() * deck.get_scale()
	var card = deck.draw_card()
	add_child(card)
	card.connect("on_accept", self, "accept_card")
	card.flip_back()
	card.set_position(deck.get_position())
	card.set_scale(size / card.get_size())
	card.set_rotation_degrees(deck.get_rotation_degrees())
	card.set_visible(true)
	var cardSize = card.get_size()
	var finalScaleX = get_viewport_rect().size.x * 0.5 / cardSize.x
	var finalPosition = (get_viewport_rect().size - (cardSize * finalScaleX)) * 0.5
	#move card to the front
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(card, "position", finalPosition, 0.8)
	tween.parallel().tween_method(card, "set_rotation_degrees", -90, 0, 0.8)
	tween.parallel().tween_property(card, "scale", Vector2(finalScaleX, finalScaleX), 0.8)
	tween.parallel().tween_callback(card, "flip_front")
	yield(tween, "finished")
	yield(self, "card_accepted")

	#remove_child(card)
	player.get_cards().append(card)
	playerMainCard.set_card(card)
	print("give player '", player.get_avatar(), "' card '", card.get_id(), "'")


func accept_card(card):
	remove_child(card)
	dice.set_enabled(true)
	emit_signal("card_accepted")


func end_turn():
	yield(draw_card(currentPlayer), "completed")
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


func _on_dice_click(dice):
	dice.set_enabled(false)
	var number = dice.get_random_number()
	number = 4
	playerSlots[currentPlayer.slot].roll_dice(number)
	yield(dice.roll(number), "completed")
	yield(move_player(currentPlayer, number), "completed")
	end_turn()
