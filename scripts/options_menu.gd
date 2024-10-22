extends Control

var full_screen = false

func _on_full_screen_pressed():
	if full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		full_screen = false
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		full_screen = true
		


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/menu.tscn")



func _on_volume_value_changed(value):
	if value == 0:
		AudioServer.set_bus_mute(0, true)
	else:
		AudioServer.set_bus_volume_db(0, value)


func _on_resolutions_item_selected(index):
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920, 1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600, 900))
		2:
			DisplayServer.window_set_size(Vector2i(1280, 720))


func _on_music_toggled(toggled_on):
	var music_bus_index = AudioServer.get_bus_index("Music")
	AudioServer.set_bus_mute(music_bus_index, !toggled_on)
