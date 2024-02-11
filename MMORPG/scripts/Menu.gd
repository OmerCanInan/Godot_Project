extends NinePatchRect
func _on_login_btn_pressed():
	global.transition_scene = true
	global.first_spawn = true
	change_world()
func change_world():
	if global.transition_scene == true:
		get_tree().change_scene_to_file("res://scenes/dunya.tscn")
		var zone = "dunya"
		global.finish_changescenes(zone)
