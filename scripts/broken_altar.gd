extends StaticBody2D

@onready var interaction_area = $InteractionArea
@onready var shop = get_tree().root.get_node("Game").get_node("CanvasLayer").get_node("Shop")
@onready var player = get_tree().root.get_node("Game").get_node("Player")
var in_shop = false

func _ready():
	interaction_area.interact = Callable(self, "_shop")
	
func _shop():
	if in_shop:
		shop.hide()
	else:
		shop.show()
		
	in_shop = !in_shop
	player.paused = in_shop

