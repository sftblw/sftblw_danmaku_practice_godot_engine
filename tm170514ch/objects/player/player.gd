extends KinematicBody2D

export(int) var SPEED_FAST = 400
export(int) var SPEED_SLOW = 200
export(float) var SHOOT_INTERVAL = 0.1

export var SHOOT_CLASS = preload("res://objects/player_bullet/player_bullet.tscn")

func _ready():
	set_fixed_process(true)
	
func _fixed_process(delta):
	__move(delta)
	__shoot(delta)
	
func __move(delta):
	var way = Vector2(0, 0)
	if Input.is_action_pressed("game_up"):    way += Vector2( 0, -1)
	if Input.is_action_pressed("game_down"):  way += Vector2( 0,  1)
	if Input.is_action_pressed("game_left"):  way += Vector2(-1,  0)
	if Input.is_action_pressed("game_right"): way += Vector2( 1,  0)
	
	if way == Vector2(0, 0): return
	
	var move_vec = way.normalized() * (SPEED_SLOW if Input.is_action_pressed("game_slow") else SPEED_FAST) * delta
	var remain = move( move_vec )
	
	if is_colliding():
		move( get_collision_normal().slide( remain ) )

var shoot_timer = 0 # TODO: timer 노드로 빼기
func __shoot(delta):
	# timer
	shoot_timer -= delta
	if shoot_timer > 0: return
	elif !Input.is_action_pressed("game_shoot"):
		shoot_timer = 0 # 누르지 않는 경우 초기화
	
	# shoot
	if Input.is_action_pressed("game_shoot"):
		var shoot = SHOOT_CLASS.instance()
		shoot.set_pos( get_node( "shoot_from" ).get_global_pos() )
		get_node("../../layer_player_bullet").add_child( shoot )
		
		shoot_timer += SHOOT_INTERVAL
	
# enemy_bullet 의 시그널 body_enter 를 받아 처리
func __check_hit(area):
	if !is_fixed_processing() or (get_node("anim").is_playing() and get_node("anim").get_current_animation() == "dead" ): return
	if area extends preload("res://objects/enemy_bullet/base_enemy_bullet.gd"):
		set_fixed_process(false)
		get_node("anim").play("dead")