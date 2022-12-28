extends Object

var avatar: String
var slot: int
var lap = 1
var cell = null
var finished = false
var cards: Array = []


func set_avatar(value):
	avatar = value


func get_avatar():
	return avatar


func set_slot(value):
	slot = value


func get_slot():
	return slot


func set_cell(value):
	cell = value


func get_cell():
	return cell


func is_finished() -> bool:
	return finished


func set_finished(value: bool):
	finished = value


func get_cards():
	return cards
