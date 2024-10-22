extends Control
@onready var game = $"../../"

func _on_restart_pressed():
	get_tree().reload_current_scene()
	game.pauseMenu()

func _on_main_menu_pressed():
	game.pauseMenu()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_quit_pressed():
	get_tree().quit()
