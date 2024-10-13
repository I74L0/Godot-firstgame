extends CharacterBody2D


const SPEED: float = 200.0
const JUMP_FORCE : float = -400.0

var isJumping : bool = false
var player_life : int = 5
var knockback_vetor := Vector2.ZERO

@onready var animation := $sprite2d as AnimatedSprite2D

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

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			animation.scale.x = direction
			if !isJumping:
				animation.play("walk")
		elif isJumping:
			animation.play("jump")
		else:
			animation.play("idle")
	
		if !(Input.is_action_pressed("left") or Input.is_action_pressed("right")):
			velocity.x = 0

		if knockback_vetor != Vector2.ZERO:
			velocity = knockback_vetor

	move_and_slide()

func _on_hurtbox_body_entered(body: Node2D) -> void:
	take_damage()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "hitbox":
		velocity.y = JUMP_FORCE
	else:
		take_damage()

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

func play_anim(animation_name):
	animation.scale.x = 1
	velocity.y = 0
	animation.play(animation_name)
