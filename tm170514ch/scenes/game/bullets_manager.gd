extends Node2D

var bullets = []

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	for blt in bullets:
		blt._fixed_process(delta)
		# bullet 도 _fixed_process를 가지지만 노드는 아니므로 직접 호출
	update() # _draw() 호출

func _draw():
	for blt in bullets:
		blt._draw()

# fire()에 의해 생성된 노드가 extends enemy_bullet 인 경우에 bullets 노드에서 관리
func add_bullet(enemy_bullet):
	pass