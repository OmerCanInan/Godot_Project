extends CharacterBody2D

var mob_respawn = false
var speed = 25
var player_chase = false
var player = null
var health = 100
var mob_inattack_range = false
var can_take_damage =true
var radius = 70
var mob_spawn_coord = Vector2(39,-63)
@onready var area = $Area2D
@onready var playernode = ("%player")
@warning_ignore("unused_parameter")
func _physics_process(delta):
	var karakter_pozisyon = self.position
	var y_koordinati = karakter_pozisyon.y
	var x_koordinati = karakter_pozisyon.x
	print(y_koordinati)
	print(global.karakter_x," ",global.karakter_y)
	death()
	deal_with_damage()
	health_bar()
	move_and_slide()
	
	if not global.mob_alive:
		return
	if player_chase and global.mob_alive and global.player_alive:
		position += ((player.position - position).normalized()) * speed * delta
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")


func _on_area_2d_body_entered(body):
	player = body
	player_chase = true



func _on_area_2d_body_exited(body):
	player = null
	player_chase = false
func enemy():
	pass


func _on_hitbox_enemy_body_entered(body):
	if body.has_method("player") and global.mob_alive:
		mob_inattack_range = true

func _on_hitbox_enemy_body_exited(body):
	if body.has_method("player") and global.mob_alive:
		mob_inattack_range = false

func deal_with_damage():
	if mob_inattack_range and global.current_player_attack and can_take_damage:
		health = health - 50
		print("mob health: ", health)
		can_take_damage = false
		$Take_damage_cooldown.start()



func _on_take_damage_cooldown_timeout():
	can_take_damage = true
	$Take_damage_cooldown.stop()

func death():
	if not global.mob_alive:
		return
	if health <= 0:
		$AnimatedSprite2D.play("dead")
		can_take_damage = false
		global.mob_alive = false 
		global.dead_finished = true


func _on_animated_sprite_2d_animation_finished():
	if global.dead_finished:
		position = Vector2(999,999)
		area.has_overlapping_areas()
		health = 0
		$respawn_timer.start()

func _on_respawn_timer_timeout():
	health = 100
	position = mob_spawn_coord
	global.mob_alive = true
	global.dead_finished = false


func health_bar():
	var healthbar = $mob_health
	healthbar.value = health
	if healthbar.value == 100:
		healthbar.visible = false
	elif healthbar.value == 0:
		healthbar.visible = false
	else:
		healthbar.visible = true
func _on_mob_recovery_timeout():
	if player_chase == false:
		if health < 100 && health >= 0:
			health = health + 20
		elif health > 100:
			health = 100
		elif health <= 0:
			health = 0
func overlap():
	var overlapping_body = area.overlaps_body($CharacterBody2D)
	if overlapping_body != null:
		player_chase = false
	
