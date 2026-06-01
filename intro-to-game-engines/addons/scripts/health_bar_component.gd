class_name HealthBarComponent extends ProgressBar
## A visual health bar that updates automatically when the linked HealthComponent changes.
@export var health_component: HealthComponent

func _ready() -> void:
	if health_component:
		# Connect the signal so we know when health changes
		health_component.health_changed.connect(_on_health_changed)
		
		# Setup initial values
		max_value = health_component.max_health
		value = health_component.current_health
		# Optional: hide the background text if desired
		show_percentage = false 
	else:
		push_warning("HealthBarComponent needs a HealthComponent assigned in the inspector.")

func _on_health_changed(current_health: int, max_health: int) -> void:
	max_value = max_health
	value = current_health
