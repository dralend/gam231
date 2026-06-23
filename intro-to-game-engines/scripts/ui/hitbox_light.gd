extends Area2D
class_name Hitbox

@export var damage: int = 1
@export var knockback_force: float = 250.0

func _ready():
	area_entered.connect(_on_area_entered)

func _on_area_entered(area):
	print("HITBOX DETECTED")
	print("Hit:", area.name)
