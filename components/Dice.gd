extends Node2D

signal roll_finished
signal click(dice)

onready var sprite: Sprite = $Sprite
onready var timer: Timer = $Timer
onready var area: Area2D = $Area2D
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


func _ready():
	randomize()


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


static func get_random_number() -> int:
	return randi() % 6 + 1


func get_size() -> Vector2:
	return sprite.texture.get_size() * sprite.get_scale()


func set_clickable(value: bool):
	if value:
		area.connect("input_event", self, "_on_input_event")
	else:
		area.disconnect("input_event", self, "_on_input_event")


func _on_input_event(viewport, event, shape_idx):
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.get_button_index() == BUTTON_LEFT
	):
		emit_signal("click", self)
