extends "res://objects/actor/caster.gd"
# Stage { Chapter, Chapter, ... }

var next_chapter = null

var managed_nodes = []
var managed_bullets = []

func fire( bullet_class, rotd, speed, pos, managed = false ):
	var bullet = .fire( bullet_class, rotd, speed, pos )
	if managed:
		if bullet extends Node2D:
			managed_nodes.push_back(bullet)
			bullet.connect("will_be_removed", self, "remove_enemy")
			WORLD.get_node("/root/Game/layer_enemy").add_child(bullet)
		# TODO
		#elif bullet extends Script: managed_bullets.push_back(bullet)
	return bullet
	
func remove_enemy(enemy):
	managed_nodes.erase(enemy)

func exit_condition():
	if managed_nodes.size() <= 0:
		return true
	else: return false

func _fixed_process(delta):
	._fixed_process(delta) # 노드가 아니므로 수동으로 호출해야 함
	self.job(delta)
	if self.exit_condition():
		return next_chapter
	else: return self

func set_next_chapter(next_chapter_class):
	if next_chapter_class == null: return null
	next_chapter = next_chapter_class.new()
	return next_chapter