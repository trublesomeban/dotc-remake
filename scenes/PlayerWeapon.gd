extends Area2D
var attacking = false
var block = false

func _ready():
	pass
func _process(_delta):
	var frame = $WeaponAnimation.frame
	block = (frame < 3 and frame > 0)
	if !attacking:
		$WeaponHitbox.disabled = true
		$WeaponAnimation.visible = false
	if Input.is_action_pressed("player_attack") and !attacking:
		$WeaponHitbox.disabled = false
		attacking = true
		$WeaponHitbox.disabled = false
		$WeaponAnimation.visible = true
		$WeaponAnimation.play("slice")
	if Input.is_action_pressed("player_right"):
		rotation_degrees = 270
	if Input.is_action_pressed("player_left"):
		rotation_degrees = 90
	if Input.is_action_pressed("player_down"):
		rotation_degrees = 0
	if Input.is_action_pressed("player_up"):
		rotation_degrees = 180


func _on_weapon_animation_animation_finished():
	#if not Input.is_action_pressed("player_attack"):
	attacking = false
	$WeaponHitbox.disabled = true
	$WeaponAnimation.visible = false
	

func _on_area_entered(area):
	var body = area.get_parent()
	if body.hit:
		body.hit(15)
