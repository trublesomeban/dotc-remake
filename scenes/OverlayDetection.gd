extends Area2D
var overlapping = false
signal player_start_overlapping_o
signal player_end_overlapping_o

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var names = []
	for object in get_overlapping_bodies():
		names.push_back(object.name)
	if "Player" in names:
		if !overlapping:
			print("started")
			overlapping = true
			player_start_overlapping_o.emit()
	else:
		if overlapping:	
			print("finished")
			overlapping = false
			player_end_overlapping_o.emit()
