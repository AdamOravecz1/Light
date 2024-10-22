extends Node2D
@onready var pause_menu = $CanvasLayer/PauseMenu
var paused = false
@onready var player = $Player
@onready var death = $CanvasLayer/Death
@onready var win = $CanvasLayer/Win

func _ready():
	pass
	#DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func _process(_delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

		
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused
	player.paused = paused


func _on_player_died():

	death.show()
	Engine.time_scale = 0
	paused = true
	player.paused = paused
	


func winner():
	win.show()
	Engine.time_scale = 0
	paused = true
	player.paused = paused
