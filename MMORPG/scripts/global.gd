extends Node
var current_scene_changed_to_dunya = false
var current_player_attack = false
var mob_alive = true
var player_alive = true
var current_scene = "dunya"
var transition_scene = false
var loading_on_dunya = true
var loading_on_zone_2 = false
var health = 100
var dead_finished = false
func finish_changescenes(zone):
	if transition_scene == true:
		transition_scene = false
	if zone == "zone_2":
		current_scene = "zone_2"
	elif zone == "dunya":
		current_scene = "dunya"
		current_scene_changed_to_dunya = true
