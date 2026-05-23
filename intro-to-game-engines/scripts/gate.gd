extends Area2D

const file_begin = "res://scenes/level/level_"

@onready var next: CollisionShape2D = $next
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D


func _on_body_entered(CollisionShape2D):
	if CollisionShape2D:
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1
		
		var next_level_path = file_begin + str(next_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
