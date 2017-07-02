tool
extends Node2D

func _ready():
	var filename_head = get_filename().replace("_res.tscn", "")
	
	for i in range(0, get_shape_count()):
		var output_array_str = str(get_shape(i).get_points()).replace("(", "").replace(")","").replace("[","").replace("]","")
		
		var file = File.new()
		file.open(filename_head + "_shape_" + str(i) + ".tres", File.WRITE)
		file.store_line("[gd_resource type=\"ConvexPolygonShape2D\" format=1]")
		file.store_line("")
		file.store_line("[resource]")
		file.store_line("")
		file.store_line("custom_solver_bias = 0.0")
		file.store_line("points = Vector2Array(" + output_array_str + ")")
		file.close()
		