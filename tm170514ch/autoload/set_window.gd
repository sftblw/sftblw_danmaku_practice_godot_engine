extends Node

func _ready():
	# https://godotengine.org/qa/485/how-to-center-game-window
	var screen_size = OS.get_screen_size()
	var window_size = OS.get_window_size()

	OS.set_window_position(screen_size*0.5 - window_size*0.5)