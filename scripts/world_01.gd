extends Node2D

@onready var player: CharacterBody2D = $player
@onready var control: Control = $HUD/control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player.player_has_died.connect(reload_game)
	control.time_is_up.connect(reload_game)
	Globals.coins = 0
	Globals.score = 0
	Globals.player_life = 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reload_game():
	await get_tree().create_timer(1).timeout
	get_tree().reload_current_scene()
