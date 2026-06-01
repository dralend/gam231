class_name HurtboxComponent extends Area2D

## Receives damage from areas in a specific group and applies it to a HealthComponent.

@export var health_component: HealthComponent
@export var attack_group_name: String = "player_attack"

func _ready() -> void:
	# Connect to Godot's built-in Area2D signal
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if not health_component:
		push_warning("HurtboxComponent needs a HealthComponent assigned in the inspector.")
		return
		
	# Check if the colliding area is in the specified attack group
	if area.is_in_group(attack_group_name):
		var damage_amount: int
		
		# Check if the attacking area has a 'damage' property or method
		if "damage" in area:
			damage_amount = area.get("damage")
		else:
			push_error("CRITICAL BUG: " + area.name + " is in the '" + attack_group_name + "' group but has no damage property!")
			return # Stop so we don't pass an uninitialized/null value
			
		health_component.take_damage(damage_amount)
