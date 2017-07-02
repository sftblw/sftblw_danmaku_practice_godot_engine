extends Node2D

# TODO: 게임 전체 플로우 관련 설계 및 작업
export(Script) var stage_class = null
var stage = null

func _ready():
	stage = stage_class.new()
	set_fixed_process(true)

func _fixed_process(delta):
	if not stage == null:
		stage._fixed_process(delta)