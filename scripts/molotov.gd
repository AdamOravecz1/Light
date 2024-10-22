extends Path2D
@onready var path_follow_2d = $PathFollow2D
@onready var molotov = $"."
@onready var player = $"../Player"
@onready var molotov_break = $Break


func _ready():
	molotov.curve.add_point(player.global_position)
	molotov.curve.add_point(get_global_mouse_position())
	

func _physics_process(delta):
	path_follow_2d.progress_ratio += delta
	
	if path_follow_2d.progress_ratio > 0.9:
		molotov_break.play()
		const FIRE = preload("res://scenes/fire.tscn")
		var new_fire = FIRE.instantiate()
		new_fire.global_position = curve.get_point_position(1)
		get_tree().root.get_node("Game").add_child(new_fire)
		molotov.visible = false
		curve.remove_point(0)
		curve.remove_point(0)
		
		
