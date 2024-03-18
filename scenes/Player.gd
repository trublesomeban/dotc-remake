extends RigidBody2D

@export var speed = 54 # How fast the player will move (pixels/sec).
@onready var parry_text_scene = load("res://scenes/parry_text.tscn")
@onready var health_display = $Control/Health
var screen_size
var sprint = 1
var max_health = 100
var health = max_health

# Called when the node enters the scene tree for the first time.
func _ready():
	update_health_display()
	screen_size = get_viewport_rect().size
	var scene_name = get_tree().root.get_child(0).name
	if scene_name == "LighthousePeak":
		position.x = 539
		position.y = 186
	else:
		position.x = 1027
		position.y = 982

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(position)
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("player_right"):
		velocity.x += 1
	if Input.is_action_pressed("player_left"):
		velocity.x -= 1
	if Input.is_action_pressed("player_down"):
		velocity.y += 1
	if Input.is_action_pressed("player_up"):
		velocity.y -= 1
	if Input.is_action_pressed("player_sprint"):
		sprint = 1.45
	else:
		sprint = 1
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed * sprint
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	move_and_collide(velocity * delta)
	
func update_health_display():
	health_display.text = str(health) + "/" + str(max_health)

func hit(damage):
	if $Weapon.attacking and $Weapon.block:
		var parry = parry_text_scene.instantiate()
		parry.position.x = 0
		parry.position.y = -15
		parry.z_index = 12
		add_child(parry)
	else: 
		health -= damage
		update_health_display()
