extends Area2D
@onready var animation_player = $AnimationPlayer

var damage = 50

func slap():
	animation_player.play("slap")



func _on_slapper_body_entered(body):
	print("laser collided with: ", body)
	if body.has_method("slapped"):
		body.slapped(damage)
