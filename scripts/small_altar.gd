extends StaticBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var point_light_2d = $PointLight2D

func turn_on():
	animated_sprite_2d.visible = true
	point_light_2d.visible = true
