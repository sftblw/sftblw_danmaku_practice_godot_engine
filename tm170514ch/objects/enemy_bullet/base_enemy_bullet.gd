extends "res://objects/actor/actor.gd"

## variables

var _pos = Vector2(0, 0) setget set_pos, get_pos
var _rot = 0 setget set_rot, get_rot
var bullets_manager = null

func set_pos(pos): _pos = pos
func get_pos(): return _pos
func set_rot(rot): _rot = rot
func get_rot(): return _rot
func set_rotd(degree): _rot = deg2rad(degree)
func get_rotd(): return rad2deg(_rot)

const _texture = null
const _shape = null
var _body = RID() setget set_body, get_body
func get_texture(): return _texture
func get_shape(): return _shape
func set_body(body): _body = body
func get_body(): return _body

## process
func process_job(delta):
	_move(delta)

## basic memeber functions

const base_enemy_class = preload("res://objects/enemy/base_enemy.gd")
var base_enemy_bullet_class = preload("res://objects/enemy_bullet/base_enemy_bullet_preload.gd").base_enemy_bullet_preload()

func fire( bullet_class, rotd, speed, pos = null ):
	if pos == null:
		pos = get_pos()

	var bullet = .fire( bullet_class, rotd, speed, pos )

	# add as child of bullet layer
	if bullet extends base_enemy_class:
		bullets_manager.get_parent().add_child(bullet)
	elif bullet extends base_enemy_bullet_class:
		bullet.bullets_manager = self.bullet_manager
		assert(bullets_manager != null)
		bullets_manager.add_bullet(bullet)
	else:
		# fired instance extends nothing of base_enemy or base_enemy_bullet
		breakpoint
	
	bullet.fired()
	
	return bullet

# init physics
func fired():
	#init_physics()
	pass
var is_physics_initialized = false
func init_physics():
	set_body( Physics2DServer.body_create(Physics2DServer.BODY_MODE_KINEMATIC) )
	Physics2DServer.body_set_space(get_body(), bullets_manager.get_world_2d().get_space())
	
	Physics2DServer.body_add_shape(get_body(), get_shape().get_rid())
	Physics2DServer.body_set_shape_as_trigger(get_body(), 0, true) # performance reason
	
	Physics2DServer.body_set_layer_mask( get_body(), 8 )
	Physics2DServer.body_set_collision_mask( get_body(), 0 ) # mask layer 4 (1, 2, 4, 8의 8)
	is_physics_initialized = true
	#process_collision() #manager에서 호출함. 여기서 하면 이중호출

func draw_to(canvas_item):
	var texture_offset = -get_texture().get_size()*0.5
	canvas_item.draw_set_transform(get_pos(), get_rot(), Vector2(1, 1))
	canvas_item.draw_texture(get_texture(), texture_offset)
	# TODO: 각도 반영

## original functions

func process_collision():
	if not is_physics_initialized: return
	var mat = Matrix32()
	mat.o = get_pos()
	mat = mat.rotated( get_rot() )
	Physics2DServer.body_set_state(get_body(), Physics2DServer.BODY_STATE_TRANSFORM, mat)

# TODO
func queue_free():
	bullets_manager.remove_bullet(self)
	
func _remove():
	bullets_manager.remove_bullet(self)

func _free_physics():
	Physics2DServer.free_rid( get_body() )