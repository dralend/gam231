extends Area2D

signal doorway_entered(doorway)
signal doorway_exited(doorway)


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		doorway_entered.emit(self)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		doorway_exited.emit(self)
