extends Area2D
@onready var valaska = $"."

signal end_of_animation
var damage = 1

func play_hit():
	valaska.visible = true
	valaska.set_collision_mask(2)
	%AnimationPlayer.play("hit")
	

func _on_animation_player_animation_finished(_anim_name):
	valaska.visible = false
	valaska.set_collision_mask(1)
	emit_signal("end_of_animation")
	


func _on_body_entered(body):
	print("valaska collided with: ", body)
	if body.has_method("take_damage"):
		body.take_damage(damage)
