extends CharacterBody2D


const SPEED: float = 2000

@onready var wall_detector := $wall_detector as RayCast2D
@onready var texture := $texture as Sprite2D

@export var enemy_score : int = 300

var direction : int = -1
var boss_life: int = 10
var is_ready: bool = false

func _physics_process(delta: float) -> void:
	if boss_life == 0:
		queue_free()
	if is_ready:
		 # Adds gravity
		if not is_on_floor():
			velocity += get_gravity() * delta

		if wall_detector.is_colliding():
			direction *= -1
			wall_detector.scale.x *= -1

		velocity.x = direction * SPEED * delta

		if get_node("anim").get_current_animation() == "hurt":
			velocity.x = 0
			get_node("hitbox/collsion").set("disabled", true)

		move_and_slide()

func set_ready():
	is_ready = true

func _on_anim_animation_finished(anim_name: StringName) -> void:
	boss_life -= 1
	get_node("anim").play("walk")
	get_node("hitbox/collsion").set("disabled", false)
