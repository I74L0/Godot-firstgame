extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if get_child(0) is Sprite2D:
		get_child(1).shape.size = get_child(0).get_rect().size


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" && body.has_method("take_damage"):
		body.take_damage()
