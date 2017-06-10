extends "res://objects/actor/actor.gd"
# 오직 Node2D를 상속하는 클래스만 상속해야 함

## variables

export(int) var HP = 10
onready var bullets_manager = get_tree().get_root().get_node("Game/layer_enemy_bullet/bullets_manager")

## process

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	process_job(delta)

## basic memeber functions

var base_enemy_class = preload("res://objects/enemy/base_enemy_preload.gd").base_enemy_preload()
const base_enemy_bullet_class = preload("res://objects/enemy_bullet/base_enemy_bullet.gd")

func fire( bullet_class, rotd, speed, pos = null ):
	if pos == null:
		if get_node("shot_pos") != null:
			pos = get_node("shot_pos").get_global_pos()
		else:
			pos = get_pos()

	var bullet = .fire( bullet_class, rotd, speed, pos )

	# add as child of bullet layer
	if bullet extends base_enemy_class:
		get_tree().get_root().get_node("Game/layer_enemy_bullet").add_child(bullet)
	elif bullet extends base_enemy_bullet_class:
		bullet.bullets_manager = self.bullets_manager
		bullets_manager.add_bullet(bullet)
	else:
		print("base_enemy.gd.fire(): extends nothing")
	
	bullet.fired()
	
	return bullet
	
## event handlers

func __deal_damage(damage):	
	HP -= damage
	
	if HP <= 0:
		queue_free()