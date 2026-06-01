class_name DamageTextComponent extends Node2D



@export var health_component: HealthComponent
@export var damage_number_scene: PackedScene

func _ready() -> void:
	if not health_component:
		push_warning("DamageTextComponent needs a HealthComponent assigned in the inspector.")
		return
	health_component.damaged.connect(_on_damaged)
	
func _on_damaged(amount: int) -> void:
	if amount <= 0 or not damage_number_scene:
		return
		
	var dmg_num: DamageNumber = damage_number_scene.instantiate()
	
	# Add to the root scene so it doesn't move with the entity
	get_tree().current_scene.add_child(dmg_num)
	
	# Position it at the global position of this component
	dmg_num.global_position = global_position
	
	# Add a slight random offset so numbers don't perfectly overlap
	var random_offset_x = randf_range(-15.0, 15.0)
	var random_offset_y = randf_range(-10.0, 10.0)
	dmg_num.global_position += Vector2(random_offset_x, random_offset_y)
	
	dmg_num.setup(amount)
