	# Stage { Chapter, Chapter, ... }
signal stage_end

var chapters = []
var chapter_initialized = false

func _fixed_process(delta):
	if chapters.size() > 0:
		if not chapter_initialized:
			chapters[0].enter()
			chapter_initialized = true
		chapters[0]._fixed_process(delta)
	
	if chapters.size() == 0:
		emit_signal("stage_end")

func pop_chapter():
	var to_remove = chapters[0]
	chapters.pop_front()
	if chapters.size() > 0:
		chapters[0].connect("chapter_end", self, "pop_chapter")

func push_chapter_by_class(chapter_class):
	chapters.push_back(chapter_class.new())
	if chapters.size() == 1:
		chapters[0].connect("chapter_end", self, "pop_chapter")