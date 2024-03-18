extends RigidBody2D

@onready var health_display = $WraithHealthDisplay/Health
@onready var player = get_parent().get_parent().get_node("Player")

var dst_player
enum {IDLE, SCREAM, ATTACK, SINK}
var state = IDLE
var player_dir = Vector2(0, 0)
var player_pos
var player_dst
var attack_duration = 0
var prev_vel
var attack_cooldown = 0
var idle_t = 0
var idle_d = 1
var max_health = 60
var health = max_health
var collided = false
var aggro = false

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 16
	#set_collision_layer_value(4, true)
	#set_collision_mask_value(4, true)
	update_health_display()
	z_index = 4
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if position.y < player.position.y:
		z_index = player.z_index - 1
	else:
		z_index = player.z_index + 1
	if health <= 0:
			sink()
	var velocity = Vector2.ZERO
	dst_player = sqrt((player.position.x - position.x) ** 2 + (player.position.y - position.y)**2)
	if state == IDLE:
		modulate.a = 0.7
		var agrange = 90
		if aggro:
			agrange += 45
		if dst_player > agrange or attack_cooldown > 0:
			$WraithAnimation.play("idle")
			if idle_d == -1:
				$WraithAnimation.flip_h = 0
			elif idle_d == 1:
				$WraithAnimation.flip_h = 1
			if attack_cooldown > 0:
				attack_cooldown -= delta
			if idle_t < 1.5:
				velocity = Vector2(1, 0) * idle_d * 0.35
				if test_move(transform, velocity):
					idle_d *= 1
				move_and_collide(velocity)
				
			elif idle_t > 2:
				if !collided:
					idle_d *= -1
				idle_t = 0
			idle_t += delta
		else:
			if !aggro:
				aggro = true
			modulate.a = 1
			player_dir = position.direction_to(player.position)
			state = SCREAM
			$WraithAnimation.play("scream")
	if state == ATTACK:
		attack_duration += delta
		if attack_duration < 0.05:
			player_dir = position.direction_to(player.position)
		if attack_duration < 0.25:
			velocity = (player_dir * attack_duration * 1200 * player_dst/95) + player_dir * 60
		else:
			velocity = (player_dir * (0.6-attack_duration) * 1000 * player_dst/95) + player_dir * 60
		if attack_duration > 0.6:
			state = IDLE
			attack_cooldown = 0.75
			#set_collision_layer_value(4, true)
			#set_collision_mask_value(4, true)
		move_and_collide(velocity * delta)
		prev_vel = velocity
	var ang = rad_to_deg(player_dir.angle())
	if state != IDLE:
		if ang > -90 and ang < 90:	
			$WraithAnimation.flip_h = 1
		else:
			$WraithAnimation.flip_h = 0



func _on_animation_finished():
	if state == SINK:
		queue_free()
	if state == SCREAM:
		player_dir = position.direction_to(player.position)
		player_pos = player.position
		player_dst = dst_player
		$WraithAnimation.play("dash")
		state = ATTACK
		attack_duration = 0
		#set_collision_layer_value(4, false)
		#set_collision_mask_value(4, false)

func sink():
	health_display.visible = false
	modulate.a = 1
	$WraithAnimation.play("sink")
	state = SINK

func update_health_display():
	health_display.text = str(health) + "/" + str(max_health)
		
func hit(damage):
	if state != IDLE:
		health -= damage
		update_health_display()


func _on_wraith_attack_area_entered(area):
	if area.name == "PlayerHitbox":
		area.get_parent().hit(25)
