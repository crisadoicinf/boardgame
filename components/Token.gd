extends Node2D

signal click(token)
onready var image: Sprite = $Image
onready var area: Area2D = $Area2D
onready var anim:AnimationPlayer = $Anim

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


func restore():
	image.set_rotation(0)


func hit():
	image.set_rotation(0)
	var tween = create_tween()
	tween.tween_property(image, "rotation", 540 * PI / 180, 0.5)
	yield(tween, "finished")


func is_moving() -> bool:
	return moving


func set_clickable(value: bool):
	if value:
		area.connect("input_event", self, "_on_input_event")
		anim.play("Selectable")
	else:
		area.disconnect("input_event", self, "_on_input_event")
		anim.stop(true)


func _on_input_event(viewport, event, shape_idx):
	if (
		event is InputEventMouseButton
		and event.is_pressed()
		and event.get_button_index() == BUTTON_LEFT
	):
		emit_signal("click", self)
