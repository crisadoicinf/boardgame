extends Node2D

onready var container: Sprite = $Container
onready var item: Sprite = $Item
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	var containerSize = container.texture.get_size() * container.get_scale()
	item.set_scale(containerSize * 0.6 / item.texture.get_size())
	set_card(null)


func set_card(card):
	if card == null:
		item.set_visible(false)
	else:
		item.set_texture(load("res://resources/items/" + card.get_id() + ".png"))
		item.set_visible(true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
