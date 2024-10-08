extends CharacterBody2D


const SPEED: float = 200.0
const JUMP_FORCE : float = -400.0

var isJumping : bool = false
var player_life : int = 10
var knockback_vetor := Vector2.ZERO

@onready var animation := $anim as AnimatedSprite2D
@onready var remote_transform := $remote as RemoteTransform2D

func _physics_process(delta: float) -> void:
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
			animation.play("run")
	elif isJumping:
		animation.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")

	if !(Input.is_action_pressed("left") or Input.is_action_pressed("right")):
		velocity.x = 0

	if knockback_vetor != Vector2.ZERO:
		velocity = knockback_vetor
	move_and_slide()


func _on_hurtbox_body_entered(body: Node2D) -> void:
	if player_life < 0:
		queue_free()
	else:
		if $ray_right.is_colliding():
			take_damage(Vector2(-200, -200))
		if $ray_left.is_colliding():
			take_damage(Vector2(200, -200))
			

func follow_camera(camera):
	var camera_path = camera.get_path()
	remote_transform.remote_path = camera_path

func take_damage(knockback_force:= Vector2.ZERO, duration := 0.25):
	player_life -= 1
	
	if knockback_force != Vector2.ZERO:
		knockback_vetor = knockback_force
		
		var knockback_tween := get_tree().create_tween()
		knockback_tween.parallel().tween_property(self, "knockback_vetor", Vector2.ZERO, duration)
		animation.modulate = Color(1, 0, 0, 1)
		knockback_tween.parallel().tween_property(animation, "modulate", Color(1, 1, 1, 1), duration)
