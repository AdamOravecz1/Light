extends CharacterBody2D
@onready var player = $"../Player"
@onready var animated_sprite = $AnimatedSprite2D
@onready var zombie = $"."
@onready var gpu_particles = $GPUParticles2D
@onready var death_sound = $DeathSound

var health = 3
var alive = true
var hurt = false
var in_hurt_direction = 0
const SPEED = 30.0
var worth = 1


func _physics_process(delta):
	if hurt:
		velocity = -in_hurt_direction * SPEED
		move_and_slide()
	elif alive and not hurt:
		var direction = global_position.direction_to(player.global_position)
		in_hurt_direction = direction
		velocity = direction * SPEED
		move_and_slide()
		if direction[0] > 0:
			animated_sprite.flip_h = true
		elif direction[0] < 0:
			animated_sprite.flip_h = false
	
func take_damage(damage):
	health -= damage
	if health > 0:
		hurt = true
		animated_sprite.play("hurt")

	elif health <= 0 and alive:
		death()
		
func on_fire(damage):
	health -= damage
	if health > 0:
		animated_sprite.play("hurt")

	elif health <= 0 and alive:
		death()
		
func death():
	death_sound.play()
	gpu_particles.emitting = true
	alive = false
	zombie.set_collision_layer(4)
	animated_sprite.play("death")
	player.add_currency(worth)

func _on_animated_sprite_2d_animation_finished():
	if health <= 0:
		queue_free()
	else:
		hurt = false
