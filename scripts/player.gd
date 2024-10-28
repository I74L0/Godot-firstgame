extends CharacterBody2D


const SPEED: float = 200.0
const JUMP_FORCE : float = -330.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_hurted : bool = false
var knockback_vetor := Vector2.ZERO
var direction: float

@onready var animation := $anim as AnimatedSprite2D

signal player_has_died()

func _physics_process(delta: float) -> void:
	if !(owner.get_node("cutscene").is_playing()):
		# Add gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_FORCE

		# Get the input direction and handle the movement/deceleration
		direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			animation.scale.x = direction
		# Stops jump movement mid-air
		elif direction == 0:
			velocity.x = 0
		
		# Handles knockback
		if knockback_vetor != Vector2.ZERO:
			velocity = knockback_vetor

	_set_state()
	move_and_slide()
	
	for plataforms in get_slide_collision_count():
		var collision = get_slide_collision(plataforms)
		if collision.get_collider().has_method("has_collided_with"):
			collision.get_collider().has_collided_with(collision, self)

# Jump action for mobile
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_FORCE

# Checks for collision with bodies
func _on_hurtbox_body_entered(body: Node2D) -> void:
	take_damage()

# Checks for collision with areas
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "hitbox":
		velocity.y = JUMP_FORCE
	else:
		take_damage()

# Take damage
func take_damage(duration : float = 0.25):
	if Globals.player_life <= 0:
		queue_free()
		emit_signal("player_has_died")
		return
	Globals.player_life -= 1
	
	var vector: Vector2 = Vector2(0, -420)
	if $ray_right.is_colliding():
		vector = Vector2(-200, -200)
	elif $ray_left.is_colliding():
		vector = Vector2(200, -200)
			
	if vector != Vector2.ZERO:
		knockback_vetor = vector
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vetor", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
	
	is_hurted = true
	await get_tree().create_timer(.3).timeout
	is_hurted = false

# Set animations on movement
func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
	elif direction != 0:
		state = "run"
		
	if is_hurted:
		state = "hurt"
	
	if animation.name != state:
		animation.play(state)

# Play player animation
func play_anim(animation_name):
	animation.scale.x = 1
	velocity.y = 0
	animation.play(animation_name)

func _on_head_collider_body_entered(body: Node2D) -> void:
	if body.has_method("break_sprite"):
		body.hitpoints -= 1
		if body.hitpoints < 0:
			body.break_sprite()
		else:
			body.animation_player.play("hit")
			body.create_coin()
