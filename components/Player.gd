extends Object

var avatar: String
var slot: int
var lap = 1
var cell = null
var finished = false
var hit = false
var cards: Array = []
var dices = 0


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


func is_hit() -> bool:
	return hit


func set_hit(value: bool):
	hit = value


func get_cards():
	return cards


func set_dices(dices: int):
	self.dices = dices


func add_dices(dices: int):
	self.dices += dices


func get_dices() -> int:
	return dices


func use_dice():
	dices -= 1


func has_active_cards() -> bool:
	for card in cards:
		if card.get_type() == "Active":
			return true
	return false
