extends Area2D

signal ladder_entered(ladder)
signal ladder_exited(ladder)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ladder_entered.emit(self)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		ladder_exited.emit(self)
