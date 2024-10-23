extends CharacterBody2D


const SPEED = 50.0
const JUMP_FORCE = -450.0

var is_jumping: bool = false
var direction: float

@onready var animation := $sprite2d as AnimatedSprite2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		is_jumping = false
	
	# Charges jump
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.x = direction * SPEED * 0.1
		is_jumping = true
	
	# Get the input direction and handle the movement/deceleration.
	direction = Input.get_axis("left", "right")
	if direction:
		if !is_jumping:
			velocity.x = direction * SPEED
		animation.scale.x = direction / 10
	# Stops jump movement mid-air
	elif direction == 0:
		velocity.x = 0
	
	# Execute jump
	if Input.is_action_just_released("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
	
	_set_state()
	move_and_slide()

# Set animations on movement
func _set_state() -> void:
	if animation.animation != "jump":
		var state = "idle"

		if Input.is_action_pressed("ui_accept"):
			state = "charging_jump"
		elif Input.is_action_just_released("ui_accept"):
			state = "jump"
		elif !is_on_floor():
			state = "fall"
		elif direction != 0:
			state = "walk"
		
		if animation.animation != state:
			animation.play(state)


func _on_sprite_2d_animation_finished() -> void:
	if animation.animation == "jump":
		animation.play("idle")
