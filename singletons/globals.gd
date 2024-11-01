extends Node

var coins: int = 0
var score: int = 0
var player_life: int = 5
var can_move: bool = true

var player = null

var current_checkpoint = null

func respawn_player():
	if current_checkpoint != null:
		player.position = current_checkpoint.global_position
