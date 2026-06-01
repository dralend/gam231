extends Node

var move_input: float = 0.0
var jump_pressed: bool = false
var up_pressed: bool = false
var down_pressed: bool = false 
var left_held: bool = false
var right_held: bool = false

func update_input():
	move_input = Input.get_axis("left", "right")
	jump_pressed = Input.is_action_just_pressed("jump")
	up_pressed = Input.is_action_pressed("up")
	down_pressed = Input.is_action_pressed("down")
	left_held = Input.is_action_pressed("left")
	right_held = Input.is_action_pressed("right")
