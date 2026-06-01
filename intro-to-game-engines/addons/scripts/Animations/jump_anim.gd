#extends Node
#
#var animation_name: String = "jump_anim"
#
#func process_animation(state: Dictionary, sprite: AnimatedSprite2D) -> void:
	#if should_play(state):
		#if sprite.animation != animation_name:
			#sprite.play(animation_name)
#
#func should_play(state: Dictionary) -> bool:
	#return (
		#not state.is_on_floor
		#and not state.is_on_ladder
		#and state.velocity.y < 0
	#)




extends Node

func should_play(state):
	return not state.is_on_floor and not state.is_on_ladder and not state.is_super_jump_active
