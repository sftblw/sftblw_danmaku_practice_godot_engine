extends Node2D

export(int) var SPEED = 100
var TIMER = 0
var job_idx = 0

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	__process_job(delta)

func __process_job(delta):
	__move(delta)

# 이하 enemy_bullet 으로부터 기본적인 움직임에 관해	

func __move(delta):
	var rot = get_rot()
	var angle_vec = Vector2( cos(rot), -sin(rot) ).normalized()
	
	set_pos( get_pos() + angle_vec * SPEED * delta )

func __set_speed(speed):
	SPEED = speed

func __set_angle(angle):
	set_rotd(angle)

var WAIT_ENABLED = false
func __wait_and_next(time, delta):
	if TIMER <= 0:
		if WAIT_ENABLED:
			job_idx += 1
			WAIT_ENABLED = false
		else:
			TIMER += time
			WAIT_ENABLED = true
	else: TIMER -= delta

func fire( bullet_class, angle, speed ):
	var shot_pos
	if get_node("shot_pos") == null:
		shot_pos = get_pos()
	else:
		shot_pos = get_node("shot_pos").get_global_pos()
	
	var bullet = bullet_class.instance()
	# set pos, speed, angle
	bullet.set_pos( shot_pos )
	bullet.__set_speed( speed )
	bullet.__set_angle( angle )
	
	# add as child of bullet layer
	get_tree().get_root().get_node("Game/layer_enemy_bullet").add_child(bullet)