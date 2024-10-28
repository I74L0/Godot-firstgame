extends CharacterBody2D
class_name EnemyBase

@onready var anim = $anim

@export var enemy_score: int = 100

const SPEED = 700.0

var wall_detector
var texture
var direction := -1

func _apply_gravity(delta):
	if not is_on_floor():
		velocity += get_gravity() * delta
	
func movement(delta):
	velocity.x = direction * SPEED * delta
	
	move_and_slide()

func flip_direction():
	if wall_detector.is_colliding():
		direction *= -1
		wall_detector.scale.x *= -1
	
	if direction == 1:
		texture.flip_h = true
	else:
		texture.flip_h = false

func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hurt":
		Globals.score += enemy_score
		queue_free()

func kill_ground_enemy(anim_name: StringName) -> void:
	if anim.anim_name == "hurt":
		kill_and_score()

func kill_air_enemy() -> void:
	kill_and_score()

func kill_and_score():
	Globals.score += enemy_score
	queue_free()
