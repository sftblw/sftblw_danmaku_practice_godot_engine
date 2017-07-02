extends Node

# ref : http://docs.godotengine.org/en/stable/learning/step_by_step/singletons_autoload.html
# ref : http://docs.godotengine.org/en/stable/learning/features/misc/background_loading.html
var current_scene = null
func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child( root.get_child_count() -1 )
	
func goto_scene(path):
	var loader = preload("res://scenes/loading/loading.tscn").instance()
	get_tree().get_root().add_child( loader )
	loader.go( path )
	