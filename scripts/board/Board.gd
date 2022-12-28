extends Node2D

onready var cells: Node2D = $Cells
onready var tokens: Node2D = $Tokens


func _ready():
	for cell in cells.get_children():
		cell.set_board(self)


func set_game(game):
	for cell in cells.get_children():
		cell.set_game(game)


func create_token(object, textureName: String):
	var token = load("res://components/Token.tscn").instance()
	token.set_object(object)
	tokens.add_child(token)
	token.set_texture(textureName)
	token.set_size(get_cell_at(0).get_middle_bag().size)
	return token


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
