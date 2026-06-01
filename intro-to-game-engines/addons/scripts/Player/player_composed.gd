extends CharacterBody2D

@onready var input: Node = $"input controller"
@onready var movement: Node = $"movement controller"
@onready var abilities: Node = $"abilities controller"
@onready var anim: Node = $"animation controller"

func _physics_process(delta):
	# 1. Read input
	input.update_input()

	# 2. Movement integrates velocity & physics
	movement.apply_movement(input, delta)
	
	# 2. Abilities run FIRST (super jump, ladders, etc.)
	abilities.update_abilities(input)

	# 4. Animation reacts to final movement state
	anim.update_animation(movement, abilities)
