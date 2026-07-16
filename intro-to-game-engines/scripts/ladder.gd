extends Area2D

var on_ladder: bool = false

func _on_ladder_body_enterd(body: Node2D) -> void:
	if "player" in body.name:
		_on_ladder = true

func _on_ladder_body_exited(body: Node2D) -> void:
	if "player" in body.name:
		_on_ladder = false
