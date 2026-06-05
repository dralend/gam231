extends Area2D
class_name Hurtbox

@export var parent: Node  # enemy or player that owns this hurtbox

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var hitbox := area as Hitbox
		if parent and parent.has_method("take_damage"):
			parent.take_damage(hitbox.damage, area.global_position, hitbox.knockback_force)
