extends Control

@onready var player = get_tree().root.get_node("Game").get_node("Player")
@onready var game = get_tree().root.get_node("Game")
@onready var point = get_tree().root.get_node("Game").get_node("Path2D").get_node("PathFollow2D")

@onready var altars = [get_tree().root.get_node("Game").get_node("SmallAltar"),
					   get_tree().root.get_node("Game").get_node("SmallAltar2"),
					   get_tree().root.get_node("Game").get_node("SmallAltar3"),
					   get_tree().root.get_node("Game").get_node("SmallAltar4"),
					   get_tree().root.get_node("Game").get_node("SmallAltar5")] 
var current_altar = 0
var current_wave = 0
const ZOMBIE = preload("res://scenes/zombie.tscn")
const SKELE = preload("res://scenes/skeleton.tscn")
const BOSS = preload("res://scenes/boss.tscn")

var wave = [[ZOMBIE.instantiate(), ZOMBIE.instantiate(), ZOMBIE.instantiate()], 
			[SKELE.instantiate(), ZOMBIE.instantiate(), ZOMBIE.instantiate()],
			[SKELE.instantiate(), SKELE.instantiate(), ZOMBIE.instantiate(), ZOMBIE.instantiate(), ZOMBIE.instantiate()],
			[SKELE.instantiate(), SKELE.instantiate(), SKELE.instantiate(), ZOMBIE.instantiate()],
			[BOSS.instantiate()]]
			

func _on_pistol_ammo_pressed():
	player.subtract_currency(1)
	player.buy(0)


func _on_blunderbuss_ammo_pressed():
	player.subtract_currency(2)
	player.buy(1)


func _on_molotov_pressed():
	player.subtract_currency(5)
	player.buy(2)


func _on_health_pressed():
	player.subtract_currency(2)
	player.buy(3)

func _on_light_pressed():
	if player.currency - 5 >= 0 and current_altar < 5:
		player.bought.play()
		player.subtract_currency(5)
		altars[current_altar].turn_on()
		current_altar += 1
	

func _on_next_pressed():
	if current_wave < wave.size():
		player.add_currency(5)
		positional()
		current_wave += 1

func positional():
	for i in wave[current_wave]:
		point.progress_ratio = randf()
		i.global_position = point.global_position
		game.add_child(i)


