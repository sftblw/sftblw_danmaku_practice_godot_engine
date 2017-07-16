extends Node

# bullet world constants
# autoloaded for easy-access (lol)

const MARGIN = 128

const WIDTH = 512
const HEIGHT = 656

const LEFT = 400
const RIGHT = 400 + WIDTH
const UP = 32
const DOWN = 32 + HEIGHT

const LEFT_WITH_MARGIN = LEFT - MARGIN
const RIGHT_WITH_MARGIN = RIGHT + MARGIN
const UP_WITH_MARGIN = UP - MARGIN
const DOWN_WITH_MARGIN = DOWN + MARGIN

func get_player():
	return get_tree().get_root().get_node("/root/Game/layer_player/player")

	
var enemy_bullet_count = 0