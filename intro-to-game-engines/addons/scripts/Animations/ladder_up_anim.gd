#extends Node
#
#var animation_name: String = "ladder_up_anim"
#
#func process_animation(state: Dictionary, sprite: AnimatedSprite2D) -> void:
	#if should_play(state):
		#if sprite.animation != animation_name:
			#sprite.play(animation_name)
#
#func should_play(state: Dictionary) -> bool:
	#return (
		#state.is_on_ladder
		#and state.is_climbing
		#and state.climb_direction < 0
	#)


extends Node

func should_play(state):
	return state.is_climbing and state.climb_direction < 0
