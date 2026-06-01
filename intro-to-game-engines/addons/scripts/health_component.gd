class_name HealthComponent extends Node

## the component that stores health and handles dammage/healing logic
signal health_changed(current_health: int, max_health: int)
signal damaged(amount: int)
signal died()


@export var max_health: int = 100
@export var actor: Node

var current_health: int

func _ready() -> void:
	current_health = max_health
	if not actor:
		push_error("Actor must be assigned")

func take_damage(amount: int) -> void:
	current_health = clampi(current_health - amount, 0, max_health)
	damaged.emit(amount)
	health_changed.emit(current_health, max_health)
	
	if current_health == 0:
		died.emit()
		if is_instance_valid(actor):
			actor.queue_free()

func heal(amount: int) -> void:
	current_health += amount
	current_health = min(current_health, max_health)
	health_changed.emit(current_health, max_health)
