extends Area2D
class_name Hurtbox

@export var damage : int = 1

func _on_body_entered(body: Node2D):
	print("Entered by:", body.name)
	if body.is_in_group("Player"):
		print("Player detected")
		body.take_damage(damage)
		#if body.is_in_group("Player"):
		#print(damage)
		#body.take_damage(damage)
