extends Node2D

const backCardTexture = preload("res://resources/objects/back_card.png")
signal on_accept(card)

onready var anim: AnimationPlayer = $Anim
onready var background: Sprite = $Container/Background
onready var infoContainer = $Container/InfoContainer
export(String) var id
export(String, "Active", "Defensive") var type
var game


func get_id() -> String:
	return id


func get_type() -> String:
	return type


func get_game():
	return game


func set_game(game):
	self.game = game


func get_size():
	return background.texture.get_size() * background.get_scale()


func flip_back():
	infoContainer.set_visible(false)
	background.set_texture(backCardTexture)


func flip_front():
	anim.play("flip_front")


func is_resource(resource: Resource) -> bool:
	return resource.get_path() == get_script().get_path()


func play(_player):
	pass
func _on_accept_pressed():
	emit_signal("on_accept", self)
