extends "res://objects/actor/actor.gd"

export(int) var HP = 10
	
func __deal_damage(damage):	
	HP -= damage
	
	if HP <= 0:
		queue_free()

var cast_angle_last = 0
var additive_last = 0
func __process_job(delta):
	if job_idx == 0:
		__set_angle( -90 )
		__set_speed( SPEED )
		job_idx += 1
	if job_idx == 1:
		if get_pos().y >= 300:
			job_idx += 1
	if job_idx == 2:
		SPEED = 0
		# 임시로 여러개 생성
		for idx in range(0, 4): # TODO: caster 노드 생성 및 구현해서 대체
			fire( preload("res://objects/enemy_bullet/enemy_bullet.tscn"), cast_angle_last * 360 / 500.0, 120)
			cast_angle_last += 360/3 + additive_last
		additive_last += 0.1
		__wait_and_next(4, delta)
	if job_idx == 3:
		TIMER -= delta # TODO: __wait()을 actor에 구현
		if TIMER <= 0:
			__set_speed( 50 )
			__set_angle( -45 )
			job_idx += 1

	__move(delta)