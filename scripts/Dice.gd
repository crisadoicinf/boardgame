extends Node2D

onready var dice: AnimatedSprite = $AnimatedSprite
var textures: Array = []
var totalTextures: Array = []
var animation = "roll"
var frames: SpriteFrames


func _ready():
	frames = dice.get_sprite_frames()
	frames.set_animation_loop(animation, false)
	var total = frames.get_frame_count(animation)
	for i in range(total):
		textures.append(frames.get_frame(animation, i))
	totalTextures.append_array(textures)
	totalTextures.append_array(textures)


func roll(number: int):
	totalTextures.shuffle()
	totalTextures.pop_back()
	totalTextures.append(textures[number - 1])
	frames.clear(animation)
	for texture in totalTextures:
		frames.add_frame(animation, texture)
	dice.set_frame(0)
	dice.play("roll")
	yield(dice, "animation_finished")
	dice.stop()


func is_rolling() -> bool:
	return dice.is_playing()


func get_random_number() -> int:
	return randi() % 6 + 1


func get_size() -> Vector2:
	return frames.get_frame(animation, dice.get_frame()).get_size()
