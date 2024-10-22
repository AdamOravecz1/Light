extends CharacterBody2D
@onready var player = $"../Player"
@onready var animated_sprite = $AnimatedSprite2D
@onready var gpu_particles = $GPUParticles2D
@onready var wand = $Wand
@onready var boss = $"."
@onready var shoot_timer = $ShootTimer
@onready var spawn_timer = $SpawnTimer
@onready var hand_timer = $HandTimer
@onready var animation_player = $AnimationPlayer
@onready var game = get_tree().root.get_node("Game")

var health = 20
var alive = true
var in_hurt_direction = 0
const SPEED = 30.0
var direction = 0
var worth = 10


func _physics_process(delta):
	if alive:
		direction = global_position.direction_to(player.global_position)
		var distance = global_position.distance_to(player.global_position)
		in_hurt_direction = direction
		velocity = direction * SPEED
		if distance > 60:
			velocity = direction * SPEED
		else:
			velocity = Vector2(0,0)
		move_and_slide()
		if direction[0] > 0:
			animated_sprite.flip_h = true
		elif direction[0] < 0:
			animated_sprite.flip_h = false
		on_correct_side()
	
func take_damage(damage):
	health -= damage
	if health > 0:
		animated_sprite.play("hurt")
		teleport()

	elif health <= 0 and alive:
		death()
		
func on_fire(damage):
	health -= damage
	if health > 0:
		animated_sprite.play("hurt")
		teleport()

	elif health <= 0 and alive:
		death()

func death():
	alive = false
	boss.set_collision_layer(4)
	animated_sprite.play("death")
	animation_player.play("death")
	player.add_currency(worth)


func _on_animated_sprite_2d_animation_finished():
	if health <= 0:
		game.winner()
		queue_free()
		wand.hand_delete()
		
func on_correct_side():
	if player.global_position.x > global_position.x:
		wand.position = Vector2(9,0)
		wand.rotation = PI/8
	elif player.global_position.x < global_position.x:
		wand.position = Vector2(-9,0)
		wand.rotation = -PI/8
		

func _on_shoot_timer_timeout():
	wand.play_shoot()
	await get_tree().create_timer(2).timeout
	wand.shoot()
	shoot_timer.stop()
	spawn_timer.start()


func _on_spawn_timer_timeout():
	wand.play_spawn()
	await get_tree().create_timer(2).timeout
	wand.spawn()
	spawn_timer.stop()
	hand_timer.start()
	
func _on_hand_timer_timeout():
	wand.play_hand()
	wand.hand()
	hand_timer.stop()
	shoot_timer.start()
	
func teleport():
	var random_angle = randf_range(0, 2 * PI)
	var random_distance = randf_range(100, 250)  # Adjust the min and max distance as needed
	var offset = Vector2(cos(random_angle), sin(random_angle)) * random_distance
	var new_position = player.global_position + offset

	# Clamp the new position to ensure it's within the bounds of -400 to 400 on both axes
	new_position.x = clamp(new_position.x, -400, 400)
	new_position.y = clamp(new_position.y, -300, 300)

	global_position = new_position
