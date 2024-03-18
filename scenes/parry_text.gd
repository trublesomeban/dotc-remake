extends Control


func _ready():
	modulate.a = 1

func _process(delta):
	modulate.a -= 2 * delta
	position.y -= 0.2
	if modulate.a <= 0:
		queue_free()
