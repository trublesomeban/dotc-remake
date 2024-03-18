extends Node
@onready var Animator = $AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_player_start_overlapping_o():
	print("recieved")
	Animator.play("fade_out_more")
	
func _on_player_end_overlapping_o():
	print("recieved")
	Animator.play("fade_in_more")

func _on_player_start_overlapping_r():
	print("recieved")
	Animator.play("fade_out_more")

func _on_player_end_overlapping_r():
	print("recieved")
	Animator.play("fade_in_more")
