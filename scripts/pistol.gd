extends Area2D

@onready var ammo_count = get_tree().root.get_node("Game").get_node("CanvasLayer").get_node("UIBL").get_node("AmmoCount")
@onready var ammo_container = get_tree().root.get_node("Game").get_node("CanvasLayer").get_node("UIBL").get_node("AmmoContainer")
@export var bullet_icon = preload("res://sprites/Bullet_icon.png")
@export var empty_bullet_icon = preload("res://sprites/Empty_Bullet_icon2.png")
@onready var marker_2d = $Marker2D

signal end_of_animation

var max_ammo = 1
var current_ammo = 0
var reserve_ammo = 0


func _ready():
	update_ammo()
	update_ammo_display()

	
func play_relode():
	%AnimationPlayer.play("relode")
	
func shoot():
	if current_ammo > 0:
		%AnimationPlayer.play("shoot")
		current_ammo -= 1
		const BULLET = preload("res://scenes/bullet.tscn")
		var new_bullet = BULLET.instantiate()
		new_bullet.global_position = %ShotingPoint.global_position
		new_bullet.global_rotation = %ShotingPoint.global_rotation
		new_bullet.damage = 2
		get_tree().root.get_node("Game").add_child(new_bullet)
		update_ammo()
		update_ammo_display()
	else:
		%AnimationPlayer.play("empty")
		
	
func relode():
	if reserve_ammo > 0 and current_ammo != max_ammo:
		var needed_ammo = max_ammo - current_ammo
		if reserve_ammo - needed_ammo < 0:
			current_ammo += reserve_ammo
			reserve_ammo = 0
		else:
			current_ammo = max_ammo
			reserve_ammo -= needed_ammo
		update_ammo()
		
	
func update_ammo():
	ammo_count.text = str(reserve_ammo)
	
func update_ammo_display():
	# Clear current icons
	for child in ammo_container.get_children():
		child.queue_free()

	# Add icons based on current_ammo
	for i in range(current_ammo):
		var icon = TextureRect.new()
		icon.texture = bullet_icon
		icon.set_custom_minimum_size(Vector2(32, 32))  # Adjust size as needed
		# Create a new CanvasItemMaterial
		var material = CanvasItemMaterial.new()
		material.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
		icon.material = material
		ammo_container.add_child(icon)
	
	for i in range(max_ammo-current_ammo):
		var icon = TextureRect.new()
		icon.texture = empty_bullet_icon
		icon.set_custom_minimum_size(Vector2(32, 32))  # Adjust size as needed
		# Create a new CanvasItemMaterial
		var material = CanvasItemMaterial.new()
		material.light_mode = CanvasItemMaterial.LIGHT_MODE_UNSHADED
		icon.material = material
		ammo_container.add_child(icon)


func _on_animation_player_animation_finished(anim_name):
	emit_signal("end_of_animation")
	update_ammo_display()


