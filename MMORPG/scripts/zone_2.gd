extends Node2D
var player = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_world()


func _on_new_map_transition_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


func _on_new_map_transition_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_world():
	if global.transition_scene == true:
		get_tree().change_scene_to_file("res://scenes/dunya.tscn")
		var zone = "dunya"
		global.finish_changescenes(zone)

