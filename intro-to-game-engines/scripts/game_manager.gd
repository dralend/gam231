extends Node

var score = 0

@onready var score_label: Label = $scoreLabel
@onready var score_label_2: Label = $scoreLabel2

func add_point():
	score += 1
	score_label.text = "You Collected " + str(score) + " coins."
	score_label_2.text = "You Collected " + str(score) + " coins."
