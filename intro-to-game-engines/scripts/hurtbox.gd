extends Area2D
class_name Hurtbox

@export var damage : int = 1

func _on_body_entered(body: Node2D):
	print("Entered by:", body.name)
	print("Player detected")
	print(damage)
	body.take_damage(damage)
	
	
