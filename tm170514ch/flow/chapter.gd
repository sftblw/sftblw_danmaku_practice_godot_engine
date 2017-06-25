extends "res://objects/actor/caster.gd"
# Stage { Chapter, Chapter, ... }

var next_chapter = null

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