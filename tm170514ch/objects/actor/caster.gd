## process

# virtual method
var _to_process = []
func _fixed_process(delta):
	for p in _to_process:
		p._process(delta)
# func process_job(delta):

## fire

static func fire( bullet_class, rotd, speed, pos ):
	var bullet
	if bullet_class extends PackedScene:
		bullet = bullet_class.instance()
	elif bullet_class extends Script:
		bullet = bullet_class.new()
	elif bullet_class extends Node2D: # actually bullet_class is bullet
		bullet = bullet_class
		WORLD.get_tree().get_root().get_node("/root/Game/layer_enemy").add_child(bullet)
	else:
		# fire target class extends nothing of PackedScene or Script.
		breakpoint
	
	# set pos, speed, angle
	bullet.set_pos( pos )
	bullet.set_speed( speed )
	bullet.set_rotd( rotd )

	return bullet
	
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
	