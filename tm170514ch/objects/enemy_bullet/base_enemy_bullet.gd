extends "res://objects/actor/actor.gd"

## variables

var _pos = Vector2(0, 0) setget set_pos, get_pos
var _rot = 0 setget set_rot, get_rot
var bullets_manager = null
const SHAPE = null

func set_pos(pos): _pos = pos
func get_pos(): return _pos
func set_rot(rot): _rot = rot
func get_rot(): return _rot
func set_rotd(degree): _rot = deg2rad(degree)
func get_rotd(): return rad2deg(_rot)

const _texture = null
func get_texture(): return _texture

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
		bullets_manager.add_bullet(bullet)
	else:
		print("base_enemy_bullet.gd.fire(): extends nothing")
		
func draw_to(canvas_item):
	var texture_offset = -get_texture().get_size()*0.5
	canvas_item.draw_set_transform(get_pos(), get_rot(), Vector2(1, 1))
	canvas_item.draw_texture(get_texture(), texture_offset)
	# TODO: 각도 반영

# TODO
func queue_free():
  bullets_manager.remove_bullet(self)