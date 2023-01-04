extends Node2D

onready var image: Sprite = $Image

var object
var moving: bool = false

# Called when the node enters the scene tree for the first time.


func set_texture(path: String):
	image.set_texture(load(path))


func get_size() -> Vector2:
	return image.texture.get_size() * image.get_scale()


func set_object(value):
	object = value


func get_object():
	return object


func move_to(value: Vector2, time: float = 0.4, trans: bool = true):
	moving = true
	var tween = create_tween()
	if trans:
		tween.set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", value, time)
	yield(tween, "finished")
	moving = false


func is_moving() -> bool:
	return moving

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
