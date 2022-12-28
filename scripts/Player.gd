extends Object

class_name Player

var cell = null
var lap = 1
var finished = false
var avatar:String
var slot:int


# Called when the node enters the scene tree for the first time.
func _ready():
	pass  # Replace with function body.


func set_cell(value):
	cell = value


func get_cell():
	return cell


func is_finished() -> bool:
	return finished


func set_finished(value: bool):
	finished = value

