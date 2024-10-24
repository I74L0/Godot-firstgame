extends Area2D


func _on_area_entered(area: Area2D) -> void:
	if area.name == "hurtbox":
		get_parent().get_node("anim").play("hurt")
