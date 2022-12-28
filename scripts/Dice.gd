extends Node2D

signal roll_finished()

onready var sprite: Sprite = $Sprite
onready var timer: Timer = $Timer
var textures =[
	preload("res://resources/dice/1.png"),
	preload("res://resources/dice/2.png"), 
	preload("res://resources/dice/3.png"), 
	preload("res://resources/dice/4.png"), 
	preload("res://resources/dice/5.png"), 
	preload("res://resources/dice/6.png")
]
var time = 0
var totalTime = 1
var rollNumber;

func _ready():
	randomize()
	
func set_number(number:int):
	sprite.set_texture(textures[number -1])
	
func roll(number: int):
	rollNumber = number
	time = 0
	timer.start()
	yield(self, "roll_finished")

func _on_timer_timeout():
	time += timer.get_wait_time()
	if(time <totalTime):
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

