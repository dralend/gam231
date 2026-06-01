extends Area2D
class_name Hurtbox

@export var damage : int = 1

func _on_body_entered(body: Node2D):
	if body.is_in_group("Player"):
		body.take_damage(damage)
