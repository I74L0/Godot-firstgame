extends Node2D

@onready var player: CharacterBody2D = $player
@onready var player_scene = preload("res://actors/player.tscn")
@onready var control: Control = $HUD/control
@onready var camera: Camera2D = $camera
@onready var player_start_position: Marker2D = $player_start_position

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Globals.player_start_position = player_start_position
	camera.set_node_to_follow("../player")
	Globals.player = player
	Globals.player.player_has_died.connect(reload_game)
	control.time_is_up.connect(game_over)

func reload_game():
	await get_tree().create_timer(1).timeout
	var player = player_scene.instantiate()
	add_child(player)
	control.reset_clock_timer()
	Globals.player = player
	Globals.player.player_has_died.connect(reload_game)
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 5
	Globals.respawn_player()

func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func _on_cutscene_animation_finished(anim_name: StringName) -> void:
	Globals.can_move = true


func _on_cutscene_animation_started(anim_name: StringName) -> void:
	Globals.can_move = false
