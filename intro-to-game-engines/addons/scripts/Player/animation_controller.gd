#extends Node
#
#@onready var player_animated_sprite: AnimatedSprite2D = %PlayerAnimatedSprite
#
#var state := {
	#"input_direction": 0.0,
	#"is_climbing": false,
	#"climb_direction": 0,
	#"is_hidden_in_doorway": false,
	#"is_on_floor": true,
	#"velocity": Vector2.ZERO,
	#"is_on_ladder": false,
	#"is_super_jump_active": false
#}
#
## Called by Player
#func update_animation(movement, abilities) -> void:
	#_collect_state(movement, abilities)
#
	## Ability-style dispatch: controller does NOT decide
	#for anim_node in get_children():
		#if anim_node.has_method("process_animation"):
			#anim_node.process_animation(state, player_animated_sprite)
#
#func _collect_state(movement, abilities) -> void:
	#var player = movement.get_parent()
#
	## Movement state
	#state.velocity = movement.velocity
	#state.is_on_floor = player.is_on_floor()
	#state.input_direction = movement.locked_direction
#
	## Super jump state
	#var super_jump = abilities.get_node_or_null("super jump ability")
	#state.is_super_jump_active = super_jump != null and super_jump.is_super_jump_active
#
	## Doorway state
	#var doorway = abilities.get_node_or_null("doorway hide ability")
	#state.is_hidden_in_doorway = doorway != null and doorway.is_hidden_in_doorway
#
	## Ladder state
	#var ladder = abilities.get_node_or_null("ladder ability")
	#if ladder != null:
		#state.is_on_ladder = ladder.on_ladder
#
		#if Input.is_action_pressed("up"):
			#state.is_climbing = true
			#state.climb_direction = -1
		#elif Input.is_action_pressed("down"):
			#state.is_climbing = true
			#state.climb_direction = 1
		#else:
			#state.is_climbing = false
			#state.climb_direction = 0
	#else:
		#state.is_on_ladder = false
		#state.is_climbing = false
		#state.climb_direction = 0

extends Node

@onready var player_animated_sprite: AnimatedSprite2D = %PlayerAnimatedSprite
# state diconary
var state = {
	"input_direction": 0.0,
	"is_climbing": false,
	"climb_direction": 0,
	"is_hidden_in_doorway": false,
	"is_on_floor": true,
	"velocity": Vector2.ZERO,
	"is_on_ladder": false,
	"is_in_door_way": false,
	"is_super_jump_active": false
}
# Called by Player
func update_animation(movement, abilities):
	# Collect required movement state
	state.velocity = movement.velocity
	state.is_on_floor = movement.get_parent().is_on_floor()
	state.input_direction = movement.locked_direction
	
	# super_jump_data
	var super_jump = abilities.get_node_or_null("super jump ability")
	if super_jump:
		state.is_super_jump_active = super_jump.is_super_jump_active
	else:
		state.is_super_jump_active = false 
	
	#doorway data
	var doorway = abilities.get_node_or_null("doorway hide ability")
	if doorway != null:
		state.is_hidden_in_doorway = doorway.is_hidden_in_doorway
	else:
		state.is_hidden_in_doorway = false
		
	# Ladder data
	var ladder = abilities.get_node_or_null("ladder ability")
	if ladder:
		state.is_on_ladder = ladder.on_ladder

		if Input.is_action_pressed("up"):
			state.is_climbing = true
			state.climb_direction = -1
		elif Input.is_action_pressed("down"):
			state.is_climbing = true
			state.climb_direction = 1
		else:
			state.is_climbing = false
			state.climb_direction = 0
	else:
		state.is_on_ladder = false

	play_animation()


 #plays the correct animation 
func play_animation():
	for anim_node in get_children():
		if anim_node.has_method("should_play") and anim_node.should_play(state):
			_play(anim_node.name)
			return
			
func _play(_name: String):
	var animation_name = _name  # use local variable
	# Only play if different from current animation
	if player_animated_sprite.animation != animation_name:
		player_animated_sprite.play(animation_name)
