extends Control

var score = 0
@onready var coins: Label = $coins

func add_point(points: int):
	score += points
	coins.text = str(score)
