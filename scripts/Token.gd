extends Node2D

onready var image: Sprite = $Image

var object
var moving: bool = false

# Called when the node enters the scene tree for the first time.


func set_texture(name: String):
	image.set_texture(load("res://resources/tokens/" + name + ".png"))


func get_size() -> Vector2:
	return image.texture.get_size() * image.get_scale()


func set_size(size: Vector2):
	image.set_scale(size / image.texture.get_size())


func set_object(value):
	object = value


func get_object():
	return object


func move_to(value: Vector2):
	moving = true
	var tween = create_tween().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", value, 0.4)
	yield(tween, "finished")
	moving = false


func is_moving() -> bool:
	return moving

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
