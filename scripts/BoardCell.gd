extends Node2D

const DIR_RIGHT = "right"
const DIR_LEFT = "left"
const DIR_UP = "up"
const DIR_DOWN = "down"
const POSITIONS = [
	[[0.5, 0.5]],
	[[0.25, 0.5], [0.75, 0.5]],
	[[0.25, 0.5], [0.625, 0.25], [0.75, 0.75]],
	[[0.25, 0.75], [0.25, 0.25], [0.75, 0.75], [0.75, 0.25]],
	[[0.25, 0.75], [0.25, 0.25], [0.5, 0.5], [0.75, 0.25], [0.75, 0.75]],
]

class_name BoardCell

onready var collision: CollisionShape2D = $Collision
var board
var objects: Array = []
var players: Array = []
var item = null


func set_board(value):
	board = value


func get_next_cell():
	return board.get_next_cell(self)


func get_prev_cell():
	return board.get_prev_cell(self)


func get_size() -> Vector2:
	return collision.get_shape().get_extents() * 2


func get_objects() -> Array:
	return objects


func add_player(player):
	objects.append(player)
	players.append(player)


func remove_player(player):
	objects.erase(player)
	players.erase(player)


func get_players() -> Array:
	return players


func set_item(value):
	if item != null:
		objects.erase(item)
	if value != null:
		objects.append(value)
	item = value


func get_item():
	return item



func get_direction():
	var from = get_position()
	var to = get_next_cell().get_position()
	if to.x < from.x:
		return DIR_LEFT
	if to.x > from.x:
		return DIR_RIGHT
	if to.y < from.y:
		return DIR_UP
	return DIR_DOWN


func get_middle_bag():
	var size = get_size() * 0.45
	var center = Rect2(get_position(), get_size()).get_center()
	return Rect2(center - size * 0.5, size)

func get_bag(object) -> Rect2:
	var positions = POSITIONS.back()
	if objects.size() <= POSITIONS.size():
		positions = POSITIONS[objects.size() - 1]
	var index = objects.find(object, 0)
	var position = [0.8, 0.5]
	if index < positions.size():
		position = positions[index]
	var x = position[0]
	var y = position[1]
	var direction = get_direction()
	if direction == DIR_RIGHT:
		x = 1 - x
	elif direction == DIR_DOWN:
		x = position[1]
		y = 1 - position[0]
	elif direction == DIR_UP:
		x = position[1]
		y = position[0]
	var size = get_size() * 0.45
	return Rect2(get_position() + get_size() * Vector2(x, y) - size * 0.5, size)
