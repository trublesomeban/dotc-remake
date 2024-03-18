extends RigidBody2D

@onready var target = get_parent().get_node("Target")

var current_path
#@onready var agent = NavigationServer2D.agent_create()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	var velocity = Vector2.ZERO
	var from_pos = position
	var to_pos = target.position
	var nav_map = NavigationServer2D.get_maps()[0]
	current_path = NavigationServer2D.map_get_path(nav_map, from_pos, to_pos, true, 4)
	if !current_path.is_empty():
		velocity = position.direction_to(current_path[1]) * delta * 45
	print(velocity)
	move_and_collide(velocity)
