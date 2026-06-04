extends Area2D
class_name Hurtbox

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		if owner.has_method("take_damage"):
			owner.take_damage(area.damage, area.global_position, area.knockback_force)
