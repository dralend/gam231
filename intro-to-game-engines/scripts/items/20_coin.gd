extends Area2D

@onready var game_manager: Control = %game_manager
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@export var value: int = 20

func _on_body_entered(body):
	game_manager.add_point(value)
	animation_player.play("pickup")
