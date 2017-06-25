extends CanvasLayer

export var move_vector = Vector2(50, 50)
var repeat_size = Vector2(0, 0)
var custom_pos = get_offset() setget set_custom_pos
func set_custom_pos(val):
	custom_pos = val
	set_offset(val)

# setter is for editor
export(ImageTexture) var bg_image = preload("res://scenes/game/bg/bg_1.png") setget set_bg_image

const WORLD = preload("res://constant/world.gd")

# for editor
func set_bg_image(val):
	bg_image = val
	# FIX ME: if set_bg_image is called by initialization before _ready, return (for in-game)
	if not has_node("bg"): return
	
	var bg = get_node("bg")
	bg.set_texture(bg_image)
	bg.set_size(bg_image.get_size())
	prepare_scroll()
	set_offset(Vector2(WORLD.LEFT, WORLD.UP))
	
	# FIX ME: don't move if this method called in editor (by checking child bg existance)
	#set_process(false)
	wrap()

func _ready():
	#set_bg_image(bg_image) #this is needless because already done in edit-time
	prepare_scroll()
	set_process(true)
	
func prepare_scroll():
	var bg = get_node("bg")
	repeat_size = bg.get_size()
	bg.set_pos(Vector2(0, 0))
	
	var size = bg.get_size()
	size.width = max((int(WORLD.WIDTH / size.width) + 2), 2) * size.width
	size.height = max((int(WORLD.HEIGHT / size.height) + 2), 2) * size.height
	bg.set_size( size )
	
	self.custom_pos = Vector2(WORLD.LEFT, WORLD.UP)

func _process(delta):
	self.custom_pos += move_vector * delta
	wrap()

func wrap():
	var bg = get_node("bg")
	var pos = self.custom_pos
	var bg_size = bg.get_size()
	
	if pos.x + bg_size.width  < WORLD.RIGHT: pos.x += repeat_size.width
	if pos.x                  > WORLD.LEFT : pos.x -= repeat_size.width
	if pos.y + bg_size.height < WORLD.DOWN : pos.y += repeat_size.height
	if pos.y                  > WORLD.UP   : pos.y -= repeat_size.height
	
	self.custom_pos = pos
