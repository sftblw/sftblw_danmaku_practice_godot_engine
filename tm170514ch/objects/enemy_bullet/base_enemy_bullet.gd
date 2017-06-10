extends "res://objects/actor/actor.gd"

## variables

var _pos = Vector2(0, 0) setget set_pos, get_pos
var _rot = 0 setget set_rot, get_rot
var bullet_manager = null

func set_pos(pos): _pos = pos
func get_pos(): return _pos
func set_rot(rot): _rot = rot
func get_rot(): return _rot
func set_rotd(degree): _rot = deg2rad(degree)
func get_rotd(): return rad2deg(_rot)

const IMAGE = preload("res://objects/enemy_bullet/enemy_bullet.png")

var bullets_manager = null

## process

## basic memeber functions

const base_enemy_class = preload("res://objects/enemy/base_enemy.gd")
var base_enemy_bullet_class = preload("res://objects/enemy_bullet/base_enemy_bullet_preload.gd").base_enemy_bullet_preload()

func fire( bullet_class, rotd, speed, pos = null ):
	if pos == null:
		if get_node("shot_pos") != null:
			pos = get_node("shot_pos").get_global_pos()
		else:
			pos = get_pos()

	var bullet = .fire( bullet_class, rotd, speed, pos )

	# add as child of bullet layer
	if bullet_class extends base_enemy_class:
		bullets_manager.get_parent().add_child(bullet)
	elif bullet_class extends base_enemy_bullet_class:
		bullet.bullets_manager = self.bullet_manager
		bullets_manager.add_bullet(bullet)

func queue_free():
  bullets_manager.remove_bullet(self)
  pass