extends Area2D
class_name Hitbox

@export var damage: int = 1
@export var knockback_force: float = 250.0


func _on_body_entered(body: Node) -> void:
	if body.has_method("take_damage"):
		body.take_damage(damage, global_position, knockback_force)
