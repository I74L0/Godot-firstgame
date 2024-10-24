extends Area2D

@onready var spikes: Sprite2D = $spikes as Sprite2D
@onready var collision: CollisionShape2D = $collision as CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	collision.shape.size = spikes.get_rect().size


func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" && body.has_method("take_damage"):
		body.take_damage()
