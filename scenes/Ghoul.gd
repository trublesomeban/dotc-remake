extends RigidBody2D

@onready var health_display = $GhoulHealthDisplay/Health
@onready var player = get_parent().get_parent().get_node("Player")
@onready var target = get_parent().get_parent().get_node("Target")

@onready var Animator = $GhoulAnimation

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
var max_health = 125
var health = max_health
var collided = false
var aggro = false
var current_path
#@onready var agent = NavigationServer2D.agent_create()

# Called when the node enters the scene tree for the first time.
func _ready():
	contact_monitor = true
	max_contacts_reported = 16
	#set_collision_layer_value(4, true)
	#set_collision_mask_value(4, true)
	update_health_display()
	z_index = 4
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO
	if position.y < player.position.y:
		z_index = player.z_index - 1
	else:
		z_index = player.z_index + 1
	if health <= 0:
			sink()
	dst_player = sqrt((player.position.x - position.x) ** 2 + (player.position.y - position.y)**2)
	
	var agrange = 85
	if aggro:
		agrange += 55
	if dst_player > agrange or attack_cooldown > 0:
		if state == IDLE:
			Animator.play("idle")
			if idle_d == -1:
				Animator.flip_h = 0
			elif idle_d == 1:
				Animator.flip_h = 1
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
	elif state != SINK:
		if !aggro:
			aggro = true
		if dst_player > 20:
			Animator.play("idle")
			var from_pos = position
			var to_pos = player.position
			var nav_map = NavigationServer2D.get_maps()[0]
			current_path = NavigationServer2D.map_get_path(nav_map, from_pos, to_pos, true, 4)
			if !current_path.is_empty():
				velocity = position.direction_to(current_path[1]) * delta * 45
				print(velocity)
			var ang = rad_to_deg(velocity.angle())
			if ang > -90 and ang < 90:	
				Animator.flip_h = 1
			else:
				Animator.flip_h = 0
			move_and_collide(velocity)
				


func _on_animation_finished():
	if state == SINK:
		queue_free()

func sink():
	health_display.visible = false
	state = SINK
	modulate.a = 1
	$GhoulAnimation.play("sink")

func update_health_display():
	health_display.text = str(health) + "/" + str(max_health)
		
func hit(damage):
	health -= damage
	update_health_display()

