extends "res://components/board/BoardCell.gd"


func on_player_step(player):
	yield(game.draw_card(player), "completed")
