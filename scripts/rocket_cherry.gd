extends EnemyBase

#@export var enemy_score: int = 200

func _ready() -> void:
	anim.animation_finished.connect(kill_air_enemy)

func _on_hitbox_body_entered(body: Node2D) -> void:
	anim.play("hurt")

#func _on_anim_animation_finished() -> void:
	#if anim.animation == "hurt":
		#queue_free()
		#Globals.score += enemy_score
