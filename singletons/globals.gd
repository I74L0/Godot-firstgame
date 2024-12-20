extends Node

var coins: int = 0
var score: int = 0
var player_life: int = 5
var can_move: bool = true

var player = null

var player_start_position = null
var current_checkpoint = null

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
	else:
		player.global_position = player_start_position.global_position
