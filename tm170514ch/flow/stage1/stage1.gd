extends "../stage.gd"

func _init():
	push_chapter_by_class(Chapter1)
	push_chapter_by_class(Chapter2)

class Chapter1 extends "res://flow/chapter.gd":
	var bgm = preload("res://audio/bgm/stage_1_common.ogg")
	func enter():
		var stream_player = WORLD.get_node("/root/Game/bgm_player")
		stream_player.set_stream(bgm)
		stream_player.play()
		stream_player.set_loop(true)

	var job_i = 0
	func job(delta):
		if wait_and_true(0.5, "job") and job_i < 5:
			var enemy_created = fire(preload("res://objects/enemy/enemy.tscn"), 0, 100, Vector2(WORLD.LEFT + WORLD.WIDTH/(5+1) * (job_i + 1), 0), true)
			enemy_created.set_script(SineEnemy)
			
			job_i += 1
	
	var exit_i = 0
	func exit_condition():
		if exit_i == 0:
			if wait_and_true(5, "exit_condition"): exit_i += 1
		if exit_i == 1:
			return .exit_condition()
			
		return false
	
	class SineEnemy extends "res://objects/enemy/base_enemy.gd":
		var sine_offset = 0
		var fire_counter = 0
		var rotation = 0
		func process_job(delta):
			if job_idx == 0:
				set_rotd(0)
				set_speed(100)
				job_idx += 1
			if job_idx == 1:
				sine_offset += delta
				set_rotd(sin(sine_offset * 4) * 45)
				if wait_and_true(2, "down"):
					set_rotd(0)
					set_speed(-30)
					job_idx += 1
			if job_idx == 2:
				if wait_and_true_for_times(0.01, "job_2_fire", 36, true):
					for i in range(0, 1):
						var idx = get_next_index_of("job_2_fire")
						fire(preload("res://objects/enemy_bullet/wide_enemy_bullet_sky.gd"), (idx - 5/2) * 39 + rotation, 300 - idx * 3)
				if wait_and_true_for_times(0.2, "job_2_fire2", 5, true):
					for i in range(0, 7):
						var bul = fire(DiamondBulletAfterGo, (i - 5/2) * 7 + rotation, 320 - i * 60)
						bul.index = i
					rotation += 360/5
				if wait_and_true(3, "job_2"):
					set_rotd( 45 if get_pos().x > WORLD.LEFT + WORLD.WIDTH / 2 else - 45)
					set_speed( 80 )
					job_idx += 1
			_move(delta)
		class DiamondBulletAfterGo extends "res://objects/enemy_bullet/diamond_enemy_bullet_blue.gd":
			var index = 0
			func process_job(delta):
				if job_idx == 0:
					if get_speed() > 50:
						set_speed( max( get_speed() - 500 * delta, 50 ) )
					if wait_and_true(0.6, "angle"):
						set_rot( WORLD.get_player().get_angle_to( get_pos() ) + PI + PI/8 * (index - 7/2) )
						job_idx += 1
				if job_idx == 1:
					if get_speed() < 100 + index * 50:
						set_speed( min( get_speed() + 500 * delta, 400 - index * 30 ) )
				_move(delta)
				
class Chapter2 extends "res://flow/chapter.gd":
	func job(delta):
		pass
		
	func exit_condition():
		var ret = wait_and_true(1, "exit_condition")
		if ret: print( str(ret) )
		return ret