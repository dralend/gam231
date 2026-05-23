extends Area2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_body_entered(_body: Node2D) -> void:
	animated_sprite_2d.play("opening")


func _on_animated_sprite_2d_animation_finished() -> void:
	animated_sprite_2d.play("open")
