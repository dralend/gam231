class_name HitboxComponent extends Area2D

## Deals damage to HurtboxComponents. Needs a CollisionShape2D child.

@export var damage: int = 10
@export var attack_group_name: String = "player_attack"

func _ready() -> void:
	# Automatically add this Area2D to the specific group so the Hurtbox can detect it
	add_to_group(attack_group_name)
