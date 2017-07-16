extends Control

func _ready():
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_pause"):
		if not get_tree().is_paused():
			get_tree().set_pause(true)
			get_node("../bgm_player").set_paused(true)
			show()
			get_node("menu/exit").grab_focus()
			get_node("menu/restart").grab_focus()
			get_node("menu/continue").grab_focus()
		else:
			handle_continue()
		accept_event()

func handle_continue():
	get_tree().set_pause(false)
	hide()
	release_focus()
	
	get_node("../bgm_player").set_paused(false)
	
func handle_restart():
	Scenes.goto_scene( "res://scenes/game/Game.tscn" )
	
func handle_exit():
	Scenes.goto_scene( "res://scenes/main/main.tscn" )