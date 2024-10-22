extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D
@onready var pivot_point_mele = $PivotPointMele
@onready var pistol = $Pistol
@onready var valaska = $PivotPointMele/Valaska
@onready var gun = $Pistol
@onready var player = $"."
@onready var blunderbus = $Blunderbus
@onready var hurtbox = $Hurtbox
@export var molotov_icon = preload("res://sprites/Molotov.png")
@onready var progress_bar = $"../CanvasLayer/UIBL/ProgressBar"
@onready var molotov_container = $"../CanvasLayer/UIBL/MolotovContainer"
@onready var currency_count = $"../CanvasLayer/UITR/CurrencyCount"
@onready var ammo_count = $"../CanvasLayer/UIBL/AmmoCount"
@onready var bought = $Bought
signal died


const SPEED = 130.0
var can_rotate = true
var can_hit = true
var left_side = false
var reloding = false
var in_dodge = false
var throw = false
var paused = false
var health = 100.0
var in_dodge_direction = 0
var molotov_amount = 0
var currency = 0
var enough = false

func _ready():
	update_molotov_count()

func _physics_process(delta):
	if not paused:
		if Input.is_action_just_pressed("primary_weapon") and not reloding:
			pistol.visible = true
			blunderbus.visible = false
			gun = $Pistol
			switch_weapon()
		if Input.is_action_just_pressed("secondary_weapon") and not reloding:
			pistol.visible = false
			blunderbus.visible = true
			gun = $Blunderbus
			switch_weapon()
		if Input.is_action_just_pressed("dodge") and can_hit:
			in_dodge = true
			gun.visible = false
			collision_mask = 1 | 4
			
			
			player.set_collision_layer(0)
			
		elif in_dodge:
			animated_sprite.play("dodge")
			velocity = in_dodge_direction * SPEED
			move_and_slide()
		elif not in_dodge:
			var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			in_dodge_direction = direction
			velocity = direction * SPEED
			move_and_slide()
			
			if direction[0] > 0:
				animated_sprite.flip_h = true
			elif direction[0] < 0:
				animated_sprite.flip_h = false


			
			if velocity.length() > 0.0:
				animated_sprite.play("run")
			else:
				animated_sprite.play("idle")
			
			if Input.is_action_just_pressed("hit"):
				can_rotate = false
				can_hit = false
				gun.visible = false
				valaska.play_hit()
				
			if Input.is_action_just_pressed("throw") and not throw and molotov_amount > 0:
				molotov_amount -= 1
				update_molotov_count()
				throw = true
				const MOLOTOV = preload("res://scenes/molotov.tscn")
				var new_molotov = MOLOTOV.instantiate()
				get_tree().root.get_node("Game").add_child(new_molotov)
				
			if get_tree().root.get_node("Game").has_node("Molotov"):
				throw = true
			else:
				throw = false
					
			

		
			if can_rotate:
				
				on_correct_side()
					
				if Input.is_action_just_pressed("shoot") and not reloding:
					gun.shoot()
					
					
				if Input.is_action_just_pressed("relode"):
					reloding = true
					gun.play_relode()
					gun.relode()
	
	if not in_dodge:
		var overlapping_mobs = hurtbox.get_overlapping_bodies()
		if overlapping_mobs.size() > 0:
			print(overlapping_mobs[0])
			health -= 5.0 * overlapping_mobs.size() * delta
			update_health()
		var is_laser = hurtbox.get_overlapping_areas()
		if is_laser.size() > 0:
			health -= 20.0 * is_laser.size() * delta
			update_health()

			
func _on_valaska_end_of_animation():
	can_rotate = true
	can_hit = true
	gun.visible = true

	

func _on_animated_sprite_2d_animation_finished():
	in_dodge = false
	gun.visible = true
	player.set_collision_layer(1)
	collision_mask = 1 | 2 | 4



func _on_blunderbus_end_of_animation():
	reloding = false


func _on_pistol_end_of_animation():
	reloding = false
	
	
	
func on_correct_side():
		# Get the global position of the mouse
	var mouse_position = get_global_mouse_position()

	# Calculate the direction from the weapon to the mouse
	var angle_direction = mouse_position - pivot_point_mele.global_position

	# Calculate the angle to the mouse
	var angle = angle_direction.angle() + PI
	# Set the weapon's rotation to face the mouse
	pivot_point_mele.rotation = angle
	gun.rotation = angle
	
	
	if mouse_position.x > global_position.x:
		pivot_point_mele.scale.y = -1
		gun.scale.y = -1
	elif mouse_position.x < global_position.x:
		pivot_point_mele.scale.y = 1
		gun.scale.y = 1
		
func switch_weapon():
	gun.update_ammo()
	gun.update_ammo_display()
	on_correct_side()
	
func update_molotov_count():
	for child in molotov_container.get_children():
		child.queue_free()
	for i in range(molotov_amount):
		var icon = TextureRect.new()
		icon.texture = molotov_icon


		# Set minimum size for the icon
		icon.set_custom_minimum_size(Vector2(32, 32))  # Adjust size as needed
		# Create a new CanvasItemMaterial
		var material = CanvasItemMaterial.new()
		material.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
		icon.material = material
		molotov_container.add_child(icon)
		
func add_currency(worth):
	currency += worth
	update_currency()
	
func subtract_currency(worth):
	if currency - worth >= 0:
		currency -= worth
		enough = true
		update_currency()
	
func update_currency():
	if currency < 10:
		currency_count.text = "00" + str(currency)
	elif currency >= 10 and currency < 100:
		currency_count.text = "0" + str(currency)
	else:
		currency_count.text = str(currency)
		
func update_health():
	if health > 100:
		health = 100
	progress_bar.value = health
	if health <= 0:
		emit_signal("died")
	
		
func laser_damage(damage):
	health -= damage
	update_health()
	
	
func slapped(damage):
	health -= damage
	update_health()
	
func skele_damage(damage):
	health -= damage
	update_health()
	
	
func buy(item):
	if enough:
		match item:
			0:
				pistol.reserve_ammo += 1
				if gun == $Pistol:
					pistol.update_ammo()
			1:
				blunderbus.reserve_ammo += 1
				if gun == $Blunderbus:
					blunderbus.update_ammo()
			2:
				molotov_amount += 1
				update_molotov_count()
			3:
				health += 30
				update_health()
		bought.play()
		enough = false
