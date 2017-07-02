extends Area2D

export(int) var SPEED = 1000
export(int) var DAMAGE = 1
var hit = false

func _ready():
	set_process( true )
	
func _process(delta):
	translate( Vector2( 0, - delta * SPEED ) )

func _on_visibility_exit_screen():
	set_process(false)
	queue_free()


func _on_shoot_body_enter( body ):
	__deal_damage( body )

func __deal_damage( body ):
	if body.has_method("__deal_damage"):
		body.__deal_damage( DAMAGE )
		__hit_something()
		
func __hit_something():
	set_process(false)
	get_node("hit_ani").play("hit")