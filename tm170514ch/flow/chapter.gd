extends "res://objects/actor/caster.gd"
# Stage { Chapter, Chapter, ... }

var next_chapter = null

var managed_nodes = []
var managed_bullets = []

signal chapter_end

const base_enemy_bullet_class = preload("res://objects/enemy_bullet/base_enemy_bullet.gd")
var bullets_manager = null
func fire( bullet_class, rotd, speed, pos, managed = false ):
	var bullet = .fire( bullet_class, rotd, speed, pos )
	if managed:
		if bullet extends Node2D:
			managed_nodes.push_back(bullet)
			bullet.connect("will_be_removed", self, "remove_enemy")
			WORLD.get_node("/root/Game/layer_enemy").add_child(bullet)
		# TODO
	if bullet extends base_enemy_bullet_class:
		if bullets_manager == null:
			bullets_manager = WORLD.get_node("/root/Game/layer_enemy_bullet/bullets_manager")
		bullet.bullets_manager = bullets_manager
		assert(bullets_manager != null)
		bullets_manager.add_bullet(bullet)
	return bullet
	
func remove_enemy(enemy):
	managed_nodes.erase(enemy)

func enter():
	pass

func job(delta):
	pass

func exit_condition():
	if managed_nodes.size() <= 0:
		return true
	else: return false

func _fixed_process(delta):
	._fixed_process(delta) # 노드가 아니므로 수동으로 호출해야 함
	job(delta)
	if exit_condition():
		emit_signal("chapter_end")