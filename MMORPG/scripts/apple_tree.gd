extends Node2D

var can_collect_apple = true
var player_in_area = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if can_collect_apple == true:
		$AnimatedSprite2D.play("apple_tree")
		if player_in_area:
			if Input.is_action_just_pressed("collect"):
				print("collected")
				can_collect_apple = false
				$growth_time.start()
	elif can_collect_apple == false:
		$AnimatedSprite2D.play("just_tree")


func _on_collectable_place_body_entered(body):
	if body.has_method("player"):
		player_in_area = true

func _on_collectable_place_body_exited(body):
	if body.has_method("player"):
		player_in_area = false


func _on_growth_time_timeout():
	can_collect_apple = true

