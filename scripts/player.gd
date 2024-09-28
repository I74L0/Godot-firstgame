extends CharacterBody2D


const SPEED = 200.0
const JUMP_FORCE = -400.0

@onready var animation := $anim as AnimatedSprite2D
var isJumping := false

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

	move_and_slide()
