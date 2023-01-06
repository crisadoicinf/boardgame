extends Node2D

signal roll_finished
signal click(dice)

onready var sprite: Sprite = $Sprite
onready var timer: Timer = $Timer
onready var area2D: Area2D = $Area2D
var bound: Rect2
var textures = [
	preload("res://resources/dice/1.png"),
	preload("res://resources/dice/2.png"),
	preload("res://resources/dice/3.png"),
	preload("res://resources/dice/4.png"),
	preload("res://resources/dice/5.png"),
	preload("res://resources/dice/6.png")
]
var time = 0
var totalTime = 1
var rollNumber
var enabled: bool = true


func _ready():
	randomize()
	bound = Rect2(Vector2(0, 0), area2D.get_child(0).get_shape().get_extents() * 2)


func set_number(number: int):
	sprite.set_texture(textures[number - 1])


func roll(number: int):
	rollNumber = number
	time = 0
	timer.start()
	yield(self, "roll_finished")


func _on_timer_timeout():
	time += timer.get_wait_time()
	if time < totalTime:
		set_number(get_random_number())
	else:
		timer.stop()
		set_number(rollNumber)
		emit_signal("roll_finished")


func is_rolling() -> bool:
	return !timer.is_stopped()


func get_random_number() -> int:
	return randi() % 6 + 1


func get_size() -> Vector2:
	return sprite.texture.get_size() * sprite.get_scale()


func set_enabled(value: bool):
	enabled = value

func _on_input_event(viewport, event, shape_idx):
	if (
		enabled
		and event is InputEventMouseButton
		and event.is_pressed()
		and event.get_button_index() == BUTTON_LEFT
	):
		if bound.has_point(to_local(event.position)):
			emit_signal("click", self)
