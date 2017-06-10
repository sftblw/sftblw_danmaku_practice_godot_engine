## variables

# var _pos (Node2D / custom)
# var _rot (Node2D / custom)
var _speed = 100 setget set_speed, get_speed
func set_speed(speed): _speed = speed
func get_speed(): return _speed
var TIMER = 0
var job_idx = 0

## process

# virtual method
# func process_job(delta):

## basic memeber functions

func _move(delta):
	var rot = get_rot()
	var angle_vec = Vector2( cos(rot), -sin(rot) ).normalized()
	
	set_pos( get_pos() + angle_vec * get_speed() * delta )

func fire( bullet_class, rotd, speed, pos ):
	var bullet
	if bullet_class extends PackedScene:
		bullet = bullet_class.instance()
	elif bullet_class extends Script:
		bullet = bullet_class.new()
	else:
		print("error: extends nothing")
	
	# set pos, speed, angle
	bullet.set_pos( pos )
	bullet.set_speed( speed )
	bullet.set_rotd( rotd )

	return bullet
	
func fired(): # 모든 의존성 설정이 다 끝난 뒤의 초기화용 함수.
	pass

## utilities

# 일정시간 후에 job_idx += 1
# 시간동안 지속적으로 호출해야 함
var WAIT_ENABLED = false
func wait_and_next(time, delta):
	if TIMER <= 0:
		if WAIT_ENABLED:
			job_idx += 1
			WAIT_ENABLED = false
		else:
			TIMER += time
			WAIT_ENABLED = true
	else: TIMER -= delta