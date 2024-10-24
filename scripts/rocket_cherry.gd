extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $anim as AnimatedSprite2D

@export var enemy_score: int = 200

func _on_hitbox_body_entered(body: Node2D) -> void:
	anim.play("hurt")

func _on_anim_animation_finished() -> void:
	if anim.animation == "hurt":
		queue_free()
		Globals.score += enemy_score
