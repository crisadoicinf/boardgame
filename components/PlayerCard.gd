extends Node2D

signal click(playerCard)

onready var container: Sprite = $Container
onready var item: Sprite = $Item
onready var area2D: Area2D = $Area2D
var bound: Rect2
var enabled: bool = true
var card = null


func _ready():
	item.set_scale(get_size() * 0.6 / item.texture.get_size())
	bound = Rect2(Vector2(0, 0), area2D.get_child(0).get_shape().get_extents() * 2)
	set_card(null)


func set_card(card):
	self.card = card
	if card == null:
		item.set_visible(false)
	else:
		item.set_texture(load("res://resources/items/" + card.get_id() + ".png"))
		item.set_visible(true)


func get_card():
	return card


func get_size() -> Vector2:
	return container.texture.get_size() * container.get_scale()


func set_enabled(value: bool):
	enabled = value


func _input(event):
	if (
		enabled
		and card != null
		and event is InputEventMouseButton
		and event.is_pressed()
		and event.get_button_index() == BUTTON_LEFT
	):
		if bound.has_point(to_local(event.position)):
			emit_signal("click", self)
