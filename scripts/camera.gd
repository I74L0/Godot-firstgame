extends Camera2D

@onready var node_to_follow: Node2D = get_node("../player")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_node_or_null("../player"):
		set_node_to_follow("../player")
		position = node_to_follow.position

func set_node_to_follow(node: NodePath):
	node_to_follow = get_node(node)
