extends Area2D
@onready var animation_player = $AnimationPlayer
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var player = get_tree().root.get_node("Game").get_node("Player")
@onready var boss = get_tree().root.get_node("Game").get_node("Boss")

var hands = []

func play_shoot():
	animated_sprite_2d.play("shoot")
	animation_player.play("shoot")

func shoot():
	var lasers = []
	for i in range(10):
		var direction = %ShotingPoint.global_position.direction_to(player.global_position)
		var angle = direction.angle() 
		const LASER = preload("res://scenes/laser.tscn")
		var new_laser = LASER.instantiate()
		new_laser.global_position = %ShotingPoint.global_position
		new_laser.global_rotation = angle + randf_range(-PI / 8, PI / 8)
		lasers.append(new_laser)
		get_tree().root.get_node("Game").add_child(lasers[i])
		await get_tree().create_timer(0.01).timeout
		
func play_spawn():
	animation_player.play("spawn")
	animated_sprite_2d.play("shoot")
	
func spawn():
	const MOB = preload("res://scenes/zombie.tscn")
	var new_mob_1 = MOB.instantiate()
	var new_mob_2 = MOB.instantiate()
	var new_mob_3 = MOB.instantiate()
	var new_mob_4 = MOB.instantiate()
	new_mob_1.global_position = boss.global_position + Vector2(0, 40)
	new_mob_2.global_position = boss.global_position + Vector2(0, -40)
	new_mob_3.global_position = boss.global_position + Vector2(40, 0)
	new_mob_4.global_position = boss.global_position + Vector2(-40, 0)
	get_tree().root.get_node("Game").add_child(new_mob_1)
	get_tree().root.get_node("Game").add_child(new_mob_2)
	get_tree().root.get_node("Game").add_child(new_mob_3)
	get_tree().root.get_node("Game").add_child(new_mob_4)
	
func play_hand():
	animation_player.play("hand")
	animated_sprite_2d.play("shoot")
	
func hand():
	const HAND = preload("res://scenes/hand.tscn")

	# Create the first hand
	var new_hand = HAND.instantiate()
	new_hand.position = Vector2(0, -40)
	player.add_child(new_hand)
	hands.append(new_hand)

	# Wait for 2 seconds
	await get_tree().create_timer(2).timeout

	# Replace the first hand with a new one
	var new_hand_2 = HAND.instantiate()
	new_hand_2.global_position = new_hand.global_position
	new_hand.queue_free()  # Queue the old hand for deletion
	get_tree().root.get_node("Game").add_child(new_hand_2)
	hands.append(new_hand_2)

	# Wait for a short time before triggering the slap
	await get_tree().create_timer(0.1).timeout
	new_hand_2.slap()
	if new_hand in hands:
		hands.erase(new_hand)

	# Wait for another 2 seconds
	await get_tree().create_timer(2).timeout

	# Queue the new hand for deletion
	new_hand_2.queue_free()

	# Remove hands from the list after they are queued for deletion

	if new_hand_2 in hands:
		hands.erase(new_hand_2)

func hand_delete():
	for hand in hands:
		if hand:
			hand.queue_free()
	hands.clear()
	


func _on_animation_player_animation_finished(anim_name):
	animation_player.play("RESET")
	
	
	

