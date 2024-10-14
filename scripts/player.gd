extends CharacterBody2D


const SPEED: float = 200.0
const JUMP_FORCE : float = -400.0

var isJumping : bool = false
var player_life : int = 5
var knockback_vetor := Vector2.ZERO

@onready var animation := $anim as AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if !(owner.get_node("cutscene").is_playing()):
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_FORCE
			isJumping = true
		elif is_on_floor():
			isJumping = false

		# Get the input direction and handle the movement/deceleration
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			animation.scale.x = direction
			if !isJumping:
				animation.play("run")
		elif isJumping:
			animation.play("jump")
		else:
			animation.play("idle")
	
		# Stops jump movement mid-air
		if !(Input.is_action_pressed("left") or Input.is_action_pressed("right")):
			velocity.x = 0
		
		# Handles knockback
		if knockback_vetor != Vector2.ZERO:
			velocity = knockback_vetor

	move_and_slide()

# Jump action for mobile
func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_FORCE
			isJumping = true
		elif is_on_floor():
			isJumping = false

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
	if player_life < 0:
		queue_free()
	player_life -= 1
	
	var vector: Vector2 = Vector2(0, -200)
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

# Play player animation
func play_anim(animation_name):
	animation.scale.x = 1
	velocity.y = 0
	animation.play(animation_name)
