extends Node2D

var vanish_target_node = null
var interactive_loader = null

onready var anim = get_node("anim")
var thread = null
var mutex = null
var function = null # 로드된 후의 처리용 함수 (func(root_before, root_after))

func go(path, function = null):
	get_tree().set_pause(true)
	var root = get_tree().get_root()
	self.function = function
	
	# 이미 이 노드가 추가되었으므로 -2가 없앨 노드
	vanish_target_node = root.get_child( root.get_child_count() - 2 )
	vanish_target_node.set_name("vanish_target_node_free")

	interactive_loader = ResourceLoader.load_interactive(path)
	assert(interactive_loader != null)
	
	anim.play("load_in")
	thread = Thread.new()
	thread.start(self, "thread_load", Thread.PRIORITY_LOW)
	mutex = Mutex.new()	

onready var progress = get_node("progress")
func update_progress():
	var res = mutex.try_lock()
	if res == ERR_BUSY:
		return
	elif res == OK:
		pass
	else:
		breakpoint
	var current = interactive_loader.get_stage()
	var count = interactive_loader.get_stage_count()
	
	mutex.unlock()
	progress.set_value( float(current) / count )
	#print("wow")
	# print(str(current) + "/" + str(count))
	

func load_end():
	var new_scene_node = interactive_loader.get_resource().instance()
	
	if function != null:
		function.call_func( vanish_target_node, new_scene_node )

	get_tree().get_root().remove_child(vanish_target_node)
	vanish_target_node.free()
	
	get_tree().get_root().add_child( new_scene_node )
	self.raise() # move to the top of parent, 이 경우엔 root의 최상위로 이동	
	
	thread.wait_to_finish()
	get_tree().set_pause(false)
	anim.play("load_out")
	

func thread_load(param):
	while(true):
		var res = mutex.try_lock()
		if res == ERR_BUSY:
			continue
		elif res == OK:
			pass
		else:
			breakpoint
			
		var poll_result = interactive_loader.poll()
	
		if poll_result == ERR_FILE_EOF: # loading finished:
			progress.set_value( 1 )
			call_deferred("load_end") # THIS IS IMPORTANT
			mutex.unlock()
			break
		elif poll_result == OK:
			update_progress()
			#call_deferred("update_progress")
		else:
			breakpoint # TODO: error during load
		mutex.unlock()