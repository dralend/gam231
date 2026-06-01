#extends Node
#
#var animation_name: String = "idle_anim"
#
#func process_animation(state: Dictionary, sprite: AnimatedSprite2D) -> void:
	#if should_play(state):
		#if sprite.animation != animation_name:
			#sprite.play(animation_name)
#
#func should_play(state: Dictionary) -> bool:
	#return (
		#state.is_on_floor
		#and state.input_direction == 0
		#and not state.is_on_ladder
	#)



extends Node

func should_play(state):
	return state.is_on_floor and state.input_direction == 0 and not state.is_on_ladder
