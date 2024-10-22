extends Area2D

var travel_distance = 0
var damage = 10

func _physics_process(delta):
	const SPEED = 1000
	const RANGE = 1200
	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	
	travel_distance += SPEED * delta
	if travel_distance > RANGE:
		queue_free()


func _on_body_entered(body):
	print("laser collided with: ", body)
	queue_free()
	if body.has_method("laser_damage"):
		body.laser_damage(damage)
	

