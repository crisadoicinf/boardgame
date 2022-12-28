extends Node2D

onready var dice = $Dice
onready var image = $Image
var player


# Called when the node enters the scene tree for the first time.
func _ready():
	dice.set_enabled(false)
	dice.set_number(dice.get_random_number())


func set_player(value):
	player = value
	image.set_texture(load("res://resources/avatars/" + player.avatar + ".png"))


func roll_dice(number):
	yield(dice.roll(number), "completed")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
