extends Node2D
@onready var n = load("res://scenes/mob.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	change_world()
func _on_new_map_transtion_body_entered(body):
	if body.has_method("player"):
		global.transition_scene = true


func _on_new_map_transtion_body_exited(body):
	if body.has_method("player"):
		global.transition_scene = false

func change_world():
	if global.transition_scene == true:
		global.loading_on_dunya = false
		global.loading_on_zone_2 = true
		get_tree().change_scene_to_file("res://scenes/zone_2.tscn")
		var zone = "zone_2"
		global.finish_changescenes(zone)

