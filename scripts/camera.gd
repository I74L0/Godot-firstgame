extends Camera2D

@onready var node_to_follow: Node2D = get_node("../player")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print("camera_position: ", self.position)
	#print(node_to_follow.name, " position is: ",node_to_follow.position)
	#print(node_to_follow.name, " remote position is: ",node_to_follow.get_node("remote").position)
	position = node_to_follow.position
	pass

func set_node_to_follow(node: NodePath) -> void:
	node_to_follow = get_node(node)
