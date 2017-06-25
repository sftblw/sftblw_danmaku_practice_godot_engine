extends Node2D

var bullets = []
var bullets_init_physics_queue = []
var MAX_PHYSICS_INIT_PER_FRAME = 4
var bullets_remove_queue = []

func _ready():
	set_process(true)
	#set_fixed_process(true)

func _process(delta):
	_init_physics_differed()
	for blt in bullets_remove_queue:
		blt._free_physics()
		bullets.erase(blt)
	bullets_remove_queue.clear()
	for blt in bullets:
		blt.process_job(delta)
		blt.process_collision()
		# bullet 도 _fixed_process를 가지지만 노드는 아니므로 직접 호출
	update()
	
	#OS.set_window_title(str(bullets.size()) + " fps: " + str(1.0 / get_process_delta_time()))

func _draw():
	for blt in bullets:
		blt.draw_to(self)

func _init_physics_differed():
	MAX_PHYSICS_INIT_PER_FRAME = 60.0 * 3 / get_process_delta_time()
	if bullets_init_physics_queue.size() > 200: print("TOO MANY UNINITIALIZED PHYSICS!")
	for i in range(0, min(bullets_init_physics_queue.size(), MAX_PHYSICS_INIT_PER_FRAME)):
		bullets_init_physics_queue[i].init_physics()
	for i in range(0, min(bullets_init_physics_queue.size(), MAX_PHYSICS_INIT_PER_FRAME)):
		bullets_init_physics_queue.pop_front()

# fire()에 의해 생성된 노드가 extends enemy_bullet 인 경우에 bullets 노드에서 관리
func add_bullet(enemy_bullet):
	bullets.push_back(enemy_bullet)
	bullets_init_physics_queue.push_back(enemy_bullet)
	
func remove_bullet(enemy_bullet):
	bullets_remove_queue.push_back(enemy_bullet)