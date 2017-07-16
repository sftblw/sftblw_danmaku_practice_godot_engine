extends TextureButton

onready var initial_pos = get_pos();
onready var tween = get_node("tween")
onready var anim = get_node("anim")

func _ready():	
	pass

func focused_anim():
	var tween_from_pos = initial_pos
	tween_from_pos.x += 64
	
	tween.interpolate_property(self, "rect/pos",\
		tween_from_pos, initial_pos,\
		0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT)

	tween.start()
	anim.play("focus_in")

func focus_out_anim():
	anim.play("focus_out")