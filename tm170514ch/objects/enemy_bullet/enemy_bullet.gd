extends "res://objects/actor/actor.gd"

# TODO: 직접 탄을 그리는 예제로 좀 더 많은 탄을 커버할 수 있게 수정
func _ready():
  OS.set_window_title( str( get_tree().get_root().get_node("Game/layer_enemy_bullet").get_child_count() ) )

func _fixed_process(delta):
  ._fixed_process(delta)
  if !get_tree().get_root().get_rect().has_point( get_pos() ):
    __on_exit_screen()

func __on_exit_screen():
  set_fixed_process(false)
  queue_free()