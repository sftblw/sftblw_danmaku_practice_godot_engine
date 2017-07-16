extends Control

func _ready():
	get_node("menu/start").grab_focus()
	
func click_start():
	Scenes.goto_scene("res://scenes/game/Game.tscn")

func click_settings():
	pass
	
func click_exit():
	get_tree().quit()