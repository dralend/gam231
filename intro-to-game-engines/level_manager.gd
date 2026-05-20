extends Node2D

@export var level_array : array [packed_scene]

var current_level : Node2D

func next_level ():
	curre_level = level_array.pop_frount().instant
