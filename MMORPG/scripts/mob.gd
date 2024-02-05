extends CharacterBody2D

var mob_respawn = false
var speed = 100
var player_chase = false
var player = null
var health = 100
var mob_inattack_range = false
var can_take_damage =true
@warning_ignore("unused_parameter")
func _physics_process(delta):
	death()
	deal_with_damage()
	health_bar()
	move_and_slide()
	if not global.mob_alive:
		return
	if player_chase and global.mob_alive and global.player_alive:
		position +=(player.position - position)/speed
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")


func _on_area_2d_body_entered(body):
	player = body
	player_chase = true


@warning_ignore("unused_parameter")
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
		$AnimatedSprite2D.visible = false
		$mob_health.visible = false
		health = 0
		global.mob_alive = false
		can_take_damage = false
		$respawn_timer.start()

func _on_respawn_timer_timeout():
	$AnimatedSprite2D.visible = true
	position = Vector2(39,-63)
	health = 100
	$mob_health.visible = true
	mob_respawn =true
	global.mob_alive = true
	can_take_damage = true
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
