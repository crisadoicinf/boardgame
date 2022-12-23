extends Object

class_name Player

var cell = null


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func set_cell(value):
	cell = value


func get_cell():
	return cell


func can_play() -> bool:
	return true
