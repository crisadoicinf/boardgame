extends Node2D
const Token = preload("res://components/Token.tscn")
onready var cells: Node2D = $Cells
onready var tokens: Node2D = $Tokens
onready var deck: Area2D = $Desk


func _ready():
	for cell in cells.get_children():
		cell.set_board(self)


func set_game(game):
	for cell in cells.get_children():
		cell.set_game(game)


func create_token(object, texturePath: String):
	var token = Token.instance()
	token.set_object(object)
	tokens.add_child(token)
	token.set_texture(texturePath)
	token.set_scale(get_cell_at(0).get_middle_bag().size / token.get_size())
	return token


func remove_token(token):
	tokens.remove_child(token)


func get_token(object):
	for token in tokens.get_children():
		if token.get_object() == object:
			return token
	return null


func adjust_tokens(cell):
	var bag
	for object in cell.get_objects():
		bag = cell.get_bag(object)
		get_token(object).move_to(bag.position)


func get_cells_length() -> int:
	return cells.get_children().size()


func get_cell_at(index: int):
	return cells.get_child(index)


func get_next_cell(cell):
	var index = (cell.get_index() + 1) % get_cells_length()
	return get_cell_at(index)


func get_prev_cell(cell):
	var index = (get_cells_length() + (cell.get_index() - 1)) % get_cells_length()
	return get_cell_at(index)


func get_deck_rect() -> Rect2:
	return Rect2(deck.get_position(), deck.get_child(0).get_shape().get_extents() * 2)
