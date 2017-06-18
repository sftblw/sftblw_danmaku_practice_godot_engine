extends "res://objects/enemy/base_enemy.gd"

var cast_angle_last = 0
var additive_last = 0
func process_job(delta):
	if job_idx == 0:
		set_rotd( 0 )
		set_speed( 100 )
		job_idx += 1
	if job_idx == 1:
		if get_pos().y >= 300:
			job_idx += 1
	if job_idx == 2:
		set_speed( 0 )
		# 임시로 여러개 생성
		for idx in range(0, 2): # TODO: caster 노드 생성 및 구현해서 대체
			if (1.0 / get_process_delta_time()) > 55.0:
				fire( preload("res://objects/enemy_bullet/diamond_enemy_bullet.gd"), cast_angle_last * 360 / 500.0, 80)
			#fire( preload("res://objects/enemy/enemy.tscn"), cast_angle_last * 360 / 500.0, 120)
			cast_angle_last += 360/3 + additive_last
		additive_last += 0.1
		wait_and_next(10, delta)
	if job_idx == 3:
		set_speed( 50 )
		set_rotd( -45 )
		job_idx += 1
	
	_move( delta )