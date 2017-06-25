extends Node2D

# TODO: 게임 전체 플로우 관련 설계 및 작업
var stage = null
func _ready():
	var initial_chapter = null
	initial_chapter = Chapter1.new()
	
	initial_chapter.set_next_chapter(Chapter2).set_next_chapter(null)
	
	stage = preload("res://flow/stage.gd").new(initial_chapter)
	set_fixed_process(true)

func _fixed_process(delta):
	if not stage == null:
		if not stage._fixed_process(delta): stage = null


class Chapter1 extends "res://flow/chapter.gd":
	var enemies = []
	var job_i = 0
	func job(delta):
		if wait_and_true(0.5, "job") and job_i < 5:
			var enemy_instance = preload("res://objects/enemy/enemy.tscn").instance()
			enemy_instance.set_script(SineEnemy)
			var enemy_created = fire(enemy_instance, 0, 100, Vector2(WORLD.LEFT + WORLD.WIDTH/(5+1) * (job_i + 1), 0))
			
			enemy_created.connect("will_be_removed", self, "remove_enemy")
			job_i += 1
	
	var exit_i = 0
	func exit_condition():
		if exit_i == 0:
			if wait_and_true(5, "exit_condition"): exit_i += 1
		if exit_i == 1:
			if enemies.size() <= 0: return true
		return false
	
	func remove_enemy(enemy):
		enemies.erase(enemy)
	
	class SineEnemy extends "res://objects/enemy/base_enemy.gd":
		var sine_offset = 0
		var fire_counter = 0
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
					set_speed(-50)
					job_idx += 1
			if job_idx == 2:
				if wait_and_true(0.5, "fire"):
					fire_counter += 1
					for i in range(0, 5):
						fire(preload("res://objects/enemy_bullet/diamond_enemy_bullet.gd"), (i - 2) * 30, 200)
				if fire_counter >= 3:
					set_rotd( 45 if get_pos().x > WORLD.LEFT + WORLD.WIDTH/2 else - 45)
					set_speed( 80 )
					job_idx += 1
			_move(delta)
	
class Chapter2 extends "res://flow/chapter.gd":
	func job(delta):
		pass
		
	func exit_condition():
		var ret = wait_and_true(1, "exit_condition")
		if ret: print( str(ret) )
		return ret