extends "res://objects/enemy_bullet/base_enemy_bullet.gd"

const _shapes = []

func init_physics():
	set_body( Physics2DServer.body_create(Physics2DServer.BODY_MODE_KINEMATIC) )
	Physics2DServer.body_set_space(get_body(), bullets_manager.get_world_2d().get_space())
	for i in range(0, _shapes.size()):
		var shape = _shapes[i]
		Physics2DServer.body_add_shape(get_body(), shape.get_rid())
		Physics2DServer.body_set_shape_as_trigger(get_body(), i, true) # performance reason
	
	Physics2DServer.body_set_layer_mask( get_body(), 8 )
	Physics2DServer.body_set_collision_mask( get_body(), 0 ) # mask layer 4 (1, 2, 4, 8의 8)
	is_physics_initialized = true
	#process_collision() #manager에서 호출함. 여기서 하면 이중호출