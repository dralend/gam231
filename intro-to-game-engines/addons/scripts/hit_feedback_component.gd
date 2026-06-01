class_name hitfeedbackcomponent extends Node

@export var health_component: HealthComponent

@export var sprite_to_flash: CanvasItem
@export var flash_color: Color = Color.RED
@export var flash_duration: float = 0.1
@export var hit_animation: String = "hit"
@export var idle_animation: String = "idle"

var original_modulate: Color = Color.WHITE
@onready var flash_timer: Timer = $Timer
var previous_health: int = -1
