extends Node2D

signal card_accepted

const Player = preload("res://components/Player.gd")

onready var board = $Board
onready var dice = $Dice
onready var playerSlots = [
	$PlayerSlots/Slot1, $PlayerSlots/Slot2, $PlayerSlots/Slot3, $PlayerSlots/Slot4
]
onready var deck = $Deck
onready var playerMainCard = $PlayercardContainer/PlayerMainCard
onready var playerDeck = $PlayercardContainer/PlayerDeck
onready var turnText:Label = $TurnText/Label
onready var totalCards = $TotalCards
onready var totalDices = $TotalDices
onready var finishTurnButton = $FinishTurnButton
onready var anim:AnimationPlayer=$Anim
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
	start_turn(players[0])


func start_turn(player):
	currentPlayer = player
	finishTurnButton.set_visible(false)
	player.set_dices(2)
	turnText.set_text(player.get_avatar() + "'s turn")
	totalCards.set_text(String(player.get_cards().size()))
	totalDices.set_text(String(player.get_dices()))
	anim.play("start_turn")
	var cards = player.get_cards().duplicate()
	playerMainCard.set_card(cards.pop_back())
	playerDeck.set_cards(cards)
	dice.set_enabled(true)
	playerMainCard.set_enabled(true)
	playerDeck.set_enabled(true)
	#yield(draw_card(player), "completed")
	#yield(draw_card(player), "completed")
	#yield(draw_card(player), "completed")
	print("'", player.get_avatar(), "' starts turn")


func move_player(player, steps):
	print("'", player.get_avatar(), "' moves '", steps, "' steps")
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
	playerMainCard.set_enabled(false)
	playerDeck.set_enabled(false)
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

	player.get_cards().append(card)
	totalCards.set_text(String(player.get_cards().size()))
	var cards = player.get_cards().duplicate()
	playerMainCard.set_card(cards.pop_back())
	playerDeck.set_cards(cards)
	print("'", player.get_avatar(), "' gets '", card.get_id(), "' card")


func accept_card(card):
	remove_child(card)
	dice.set_enabled(true)
	playerMainCard.set_enabled(true)
	playerDeck.set_enabled(true)
	emit_signal("card_accepted")


func end_turn(player):
	yield(draw_card(player), "completed")
	print("'", player.get_avatar(), "' ens turn")
	var index = players.find(player, 0)
	index = (index + 1) % players.size()
	var nextPlayer = players[index]
	while nextPlayer.is_finished() and nextPlayer != player:
		index = (index + 1) % players.size()
		nextPlayer = players[index]
	if nextPlayer == player and nextPlayer.is_finished():
		end_game()
	else:
		start_turn(nextPlayer)


func end_game():
	print("end game")
	
	
func roll_dice(player)->int:
	player.use_dice()
	totalDices.set_text(String(player.get_dices()))
	var number = dice.get_random_number()
	print("'", player.get_avatar(), "' throws dice '", number, "'")
	playerSlots[player.slot].roll_dice(number)
	yield(dice.roll(number), "completed")
	return number


func _on_dice_click(dice):
	dice.set_enabled(false)
	var player = currentPlayer
	var number = yield(roll_dice(player), "completed")
	number=4
	yield(move_player(player, number), "completed")
	finishTurnButton.set_visible(player.get_dices() == 0)
	if player.get_dices() == 0 and !player.has_active_cards():
		end_turn(player)


func _on_finish_turn_pressed():
	end_turn(currentPlayer)

var _openingDeck = false


func _on_player_card_click(playerCard):
	if (
		playerCard == playerMainCard
		and currentPlayer.get_cards().size() > 1
		and !playerDeck.is_visible()
	):
		_openingDeck = true
		playerDeck.show()
	else:
		playerDeck.hide()
		#play card
		print("'", currentPlayer.get_avatar(), " plays card '", playerCard.get_card().get_id(), "'")


func _input(event):
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.get_button_index() == BUTTON_LEFT
	):
		if !_openingDeck and playerDeck.is_visible():
			playerDeck.hide()
		_openingDeck = false

