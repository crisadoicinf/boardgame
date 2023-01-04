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


func move_token(player, token, target):
	var cell = player.get_cell()
	var behind = cell.get_distance_behind(target.get_cell())
	var ahead = cell.get_distance_ahead(target.get_cell())
	var steps = min(behind, ahead)
	for i in range(steps):
		if behind < ahead:
			cell = cell.get_prev_cell()
		else:
			cell = cell.get_next_cell()
		if i < steps - 1:
			yield(token.move_to(cell.get_middle_bag().position, 0.2, false), "completed")
	yield(token.move_to(game.get_board().get_token(target).get_position(), 0.2, false), "completed")


func _on_accept_pressed():
	emit_signal("on_accept", self)
