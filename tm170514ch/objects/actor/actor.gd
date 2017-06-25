extends "caster.gd"
## variables

# var _pos (Node2D / custom)
# var _rot (Node2D / custom)
var _speed = 100 setget set_speed, get_speed
func set_speed(speed): _speed = speed
func get_speed(): return _speed
var TIMER = 0
var job_idx = 0

## signals
signal will_be_removed

## basic memeber functions

func _move(delta):
	var rot = get_rot()
	var angle_vec = Vector2(1, 0).rotated(rot-PI/2).normalized()
	
	set_pos( get_pos() + angle_vec * get_speed() * delta )
	
	if !remove_requested and _is_outside_game():
		remove_requested = true
		emit_signal("will_be_removed", self)
		_remove()

var remove_requested = false
func _remove(): ## abstract
	pass
	
func fired(): # 모든 의존성 설정이 다 끝난 뒤의 초기화용 함수.
	pass



#world constants

const WORLD = preload("res://constant/world.gd")
func _is_outside_game():
	var pos = get_pos()
	if pos.x < WORLD.LEFT_WITH_MARGIN or pos.x > WORLD.RIGHT_WITH_MARGIN or pos.y < WORLD.UP_WITH_MARGIN or pos.y > WORLD.DOWN_WITH_MARGIN:
		return true
	else: return false