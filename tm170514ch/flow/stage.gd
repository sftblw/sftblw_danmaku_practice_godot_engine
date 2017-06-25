# Stage { Chapter, Chapter, ... }
signal stage_end

var current_chapter = null

func _fixed_process(delta):
	if current_chapter != null:
		current_chapter = current_chapter._fixed_process(delta)
		return true
	if current_chapter == null:
		emit_signal("stage_end")
		return false
		
func _init(initial_chapter):
	self.current_chapter = initial_chapter