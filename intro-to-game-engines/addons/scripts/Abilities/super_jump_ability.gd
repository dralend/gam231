extends Node

@export var super_jump_force: float = 800.0
var is_super_jump_active: bool = false

func process_ability(input) -> void:
	var player = get_parent().player_composed
	var movement_controller = get_parent().movement_controller

	# Only apply super jump if the input is pressed and jump is allowed
	if (input.up_pressed and input.jump_pressed 
	and not is_super_jump_active 
	and movement_controller.can_jump
	and not movement_controller.vertical_locked):

		player.velocity.y = -super_jump_force
		is_super_jump_active = true
	elif player.is_on_floor():
		# Reset once the player lands
		is_super_jump_active = false










#extends Node
#
#@export var super_jump_force: float = 256.0
#var request_super_jump: bool = false
#var is_super_jump_active: bool = false
#
#
#func process_ability(input):
	## Detect super jump input (up + jump)
	#if input.up_pressed and input.jump_pressed and not is_super_jump_active :
		#request_super_jump = true
	#else:
		#request_super_jump = false
		#
#func post_movement(_movement):
	#var player_composed = get_parent().player_composed
	#var movement_controller = get_parent().movement_controller
	#if request_super_jump and movement_controller.can_jump == true:
		#player_composed.velocity.y = -super_jump_force
		#is_super_jump_active = true
	#elif player_composed.is_on_floor():
		#is_super_jump_active = false 
		
