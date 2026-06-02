extends Node2D
class_name trap

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

func _on_killzone_body_entered(body: Node2D) -> void:
	animated_sprite_2d.play("spike_trap")
