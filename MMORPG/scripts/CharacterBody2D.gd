extends CharacterBody2D
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var attack_ip = false
const speed = 80
var current_dir = "down"
const FRICTION = 30
var dead_finished = false
var wait_time = false
@export var inta = 1


func _physics_process(delta): 
	enemy_attack()
	player_movement(delta)
	attack()
	current_cam()
	spawnpoint()
	death()
	disappear()
	health_bar()
	var karakter_pozisyon = self.position
	var y_koordinati = karakter_pozisyon.y
	var x_koordinati = karakter_pozisyon.x
	print("Karakter Pozisyonu: ", karakter_pozisyon) 
	print("X Koordinatı: ", x_koordinati)    
	print("Y Koordinatı: ", y_koordinati)    
	global.karakter_x =  x_koordinati
	global.karakter_y = y_koordinati
func player_movement(delta):
	if global.player_alive:
		if Input.is_action_pressed("d"):
			velocity.x = speed
			play_anim(1)
			velocity.y = 0
			current_dir = "right"
		elif Input.is_action_pressed("a"): 
			velocity.x = -speed
			play_anim(1)
			velocity.y = 0
			current_dir = "left"
		elif  Input.is_action_pressed("s"):
			velocity.x = 0
			play_anim(1)
			velocity.y = speed
			current_dir ="down"
		elif Input.is_action_pressed("w"):
			velocity.x = 0
			play_anim(1)
			velocity.y = -speed
			current_dir = "up" 
		else:
			play_anim(0)
			velocity.x = 0
			velocity.y = 0
		move_and_slide();
func play_anim(movement):
	var dir = current_dir
	var anim = $AnimatedSprite2D
	if global.player_alive == true:
		if dir == "right":
			anim.flip_h = false
			if movement == 1:
				anim.play("left_walk")
			elif movement == 0:
				if attack_ip == false:
					anim.play("left_idle")
		if dir == "left":
			anim.flip_h = true
			if movement == 1:
				anim.play("left_walk")
			elif movement == 0:
				if attack_ip == false:
					anim.play("left_idle")
		if dir == "down":
			anim.flip_h = false
			if movement == 1:
				anim.play("front_walk")
			elif movement == 0:
				if attack_ip == false:
					anim.play("front_idle")
		if dir == "up":
			anim.flip_h = false
			if movement == 1:
				anim.play("back_walk")
			elif movement == 0:
				if attack_ip == false:
					anim.play("back_idle")
func player():
	pass
func _on_hitbox_player_body_entered(body):
	if body.has_method("enemy") && global.player_alive:
		enemy_inattack_range = true
func _on_hitbox_player_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false
func enemy_attack():
	if enemy_inattack_range and  enemy_attack_cooldown and global.mob_alive:
		global.health = global.health - 10
		enemy_attack_cooldown = false
		$cooldown_timer.start()
		print(global.health)
func _on_cooldown_timer_timeout():
	enemy_attack_cooldown = true
func attack():
	var dir = current_dir
	if Input.is_action_pressed("hit") && global.player_alive:
		global.current_player_attack = true
		attack_ip = true
		if dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("left_attack")
			$deal_attack_timer.start()
		if dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("left_attack")
			$deal_attack_timer.start()
		if dir == "down":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if dir == "up":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()
func _on_deal_attack_timer_timeout():
	$deal_attack_timer.stop()
	global.current_player_attack = false
	attack_ip = false
func released():
	if Input.is_action_just_pressed("hit"):
		if current_dir == "right":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("left_attack")
			$deal_attack_timer.start()
		if current_dir == "left":
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("left_attack")
			$deal_attack_timer.start()
		if current_dir == "down":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("front_attack")
			$deal_attack_timer.start()
		if current_dir == "up":
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("back_attack")
			$deal_attack_timer.start()
func current_cam():
	if global.current_scene == "dunya":
		$dunya_cam.enabled = true
		$zone_2_cam.enabled = false
	elif global.current_scene == "zone_2":
		$dunya_cam.enabled = false
		$zone_2_cam.enabled = true
func spawnpoint(): 
	if global.current_scene_changed_to_dunya and global.first_spawn:
		position = Vector2(15,15)
		global.current_scene_changed_to_dunya = false
		global.first_spawn = false
	elif global.current_scene_changed_to_dunya:
		position = Vector2(167,27)
		global.current_scene_changed_to_dunya = false
func disappear():
	if dead_finished:
		print("a")
		$AnimatedSprite2D.visible = false
		dead_finished = false
		global.player_alive = false
func death():
	if global.health <= 0 && not dead_finished && wait_time == false:
		print("player dead")
		global.player_alive = false
		global.health = 0
		enemy_inattack_range = false
		$health_bar.visible = false
		$AnimatedSprite2D.play("dead")
		$death_timer.start()
		wait_time = true
		$AnimatedSprite2D.visible = false
		$dunya_cam.enabled = false
		$death_cam.enabled = true

func health_bar():
	var healthbar = $health_bar
	healthbar.value = global.health
	if healthbar.value == 100 || healthbar.value == 0:
		healthbar.visible = false
	else:
		healthbar.visible = true
		


func _on_health_recovery_timeout():
	if enemy_inattack_range == true:
		pass
	elif global.player_alive == false :
		pass
	else:
		if global.health < 100 && global.health >= 0:
			global.health = global.health + 20
			print(global.health)
		elif global.health >= 100:
			global.health = 100
			print(global.health)
		elif global.health == 0:
			global.health = 0
			print(global.health)

