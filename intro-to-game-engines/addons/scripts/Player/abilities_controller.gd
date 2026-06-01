extends Node

@onready var player_composed: CharacterBody2D = $".."
@onready var movement_controller: Node = $"../movement controller"

func update_abilities(input):
	for ability in get_children():
		ability.process_ability(input)
