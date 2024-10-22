extends CharacterBody2D
@onready var player = $"../Player"
@onready var animated_sprite = $AnimatedSprite2D
@onready var skeleton = $"."
@onready var laser = $Laser
@onready var line = $Laser/Line2D
@onready var animation_player = $Laser/AnimationPlayer
@onready var ray_cast_2d = $Laser/RayCast2D
@onready var charge = $Laser/AnimationPlayer/Charge
@onready var bones = $Bones
@onready var target_light = $Laser/TargetLight

@onready var hitbox = $Laser/Hitbox



var health = 2
var alive = true
var hurt = false
var aim = false
var in_hurt_direction = 0
const SPEED = 30.0
const damage = 15
var worth = 1


func _physics_process(delta):
	var direction = global_position.direction_to(player.global_position)
	if hurt:
		velocity = -in_hurt_direction * SPEED
		move_and_slide()
	
	elif alive and not hurt:
		var distance = global_position.distance_to(player.global_position)
		
		in_hurt_direction = direction
		if distance > 120:
			velocity = direction * SPEED
		else:
			velocity = -direction * SPEED
		move_and_slide()
		if direction[0] > 0:
			animated_sprite.flip_h = true
			laser.position = Vector2(3, -8)
		elif direction[0] < 0:
			animated_sprite.flip_h = false
			laser.position = Vector2(-3, -8)
		
	if aim and alive and not hurt:
		laser.visible = true
		create_laser(direction)
	else:
		laser.visible = false
			
		
		

func create_laser(direction):
	
	var angle = direction.angle() + PI
	laser.rotation = angle

	var distance = 500
	if ray_cast_2d.is_colliding():
		distance = laser.global_position.distance_to(ray_cast_2d.get_collision_point())


	line.clear_points()
	line.add_point(Vector2(0, 0))
	line.add_point(Vector2(-distance, 0))
	if distance < 500:
		target_light.position.x = -distance
	else:
		target_light.position.x = 0

	hitbox.shape.length = distance + 3


	
func take_damage(damage):
	health -= damage
	animation_player.stop()
	charge.stop()
	if health > 0:
		hurt = true
		animated_sprite.play("hurt")

	elif health <= 0 and alive:
		death()
		
func on_fire(damage):
	health -= damage
	animation_player.stop()
	charge.stop()
	laser.visible = false
	if health > 0:
		animated_sprite.play("hurt")

	elif health <= 0 and alive:
		death()
		
func death():
	bones.play()
	alive = false
	skeleton.set_collision_layer(4)
	
	animated_sprite.play("death")
	player.add_currency(worth)

func _on_animated_sprite_2d_animation_finished():
	aim = false
	if health <= 0:
		queue_free()
	else:
		hurt = false
		animated_sprite.play("walk")
		
		

func _on_timer_timeout():
	if alive:
		animated_sprite.play("shoot")
		animation_player.play("thicken_laser")
		aim = true
	


func _on_laser_body_entered(body):
	hitbox.shape.length = 1	
	print("laser collided with: ", body)
	if body.has_method("skele_damage"):
		body.skele_damage(damage)
