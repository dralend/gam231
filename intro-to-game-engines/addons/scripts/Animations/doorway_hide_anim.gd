#extends Node
#
#var animation_name: String = "doorway_hide_anim"
#
#func process_animation(state: Dictionary, sprite: AnimatedSprite2D) -> void:
	#if should_play(state):
		#if sprite.animation != animation_name:
			#sprite.play(animation_name)
#
#func should_play(state: Dictionary) -> bool:
	#return state.is_hidden_in_doorway
	

extends Node

func should_play(state):
	return state.is_hidden_in_doorway
