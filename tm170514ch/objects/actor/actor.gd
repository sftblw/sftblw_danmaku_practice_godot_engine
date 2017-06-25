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
var _to_process = []
func _fixed_process(delta):
	for p in _to_process:
		p._process(delta)
# func process_job(delta):

## basic memeber functions

func _move(delta):
	var rot = get_rot()
	var angle_vec = Vector2(1, 0).rotated(rot-PI/2).normalized()
	
	set_pos( get_pos() + angle_vec * get_speed() * delta )
	
	if !remove_requested and _is_outside_game():
		remove_requested = true
		_remove()

var remove_requested = false
func _remove(): ## abstract
	pass

func fire( bullet_class, rotd, speed, pos ):
	var bullet
	if bullet_class extends PackedScene:
		bullet = bullet_class.instance()
	elif bullet_class extends Script:
		bullet = bullet_class.new()
	else:
		# fire target class extends nothing of PackedScene or Script.
		breakpoint
	
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
var __timer = {}
func wait_and_true(time, timer_id):
	if not __timer.has(timer_id):
		__timer[timer_id] = CountedTimer.new()
		_to_process.push_back(__timer[timer_id])
	if not __timer[timer_id].active:
		__timer[timer_id].active = true
		__timer[timer_id].timer = time
	if __timer[timer_id].matched > 0:
		__timer[timer_id].matched -= 1
		return true
	else: return false

class CountedTimer:
	var timer = 0
	var matched = 0
	var active = false
	func _process(delta):
		if active:
			if timer > 0: timer -= delta
			if timer <= 0:
				matched += 1
				active = false

#world constants

const WORLD = preload("res://constant/world.gd")
func _is_outside_game():
	var pos = get_pos()
	if pos.x < WORLD.LEFT_WITH_MARGIN or pos.x > WORLD.RIGHT_WITH_MARGIN or pos.y < WORLD.UP_WITH_MARGIN or pos.y > WORLD.DOWN_WITH_MARGIN:
		return true
	else: return false