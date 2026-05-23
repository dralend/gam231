extends Area2D


func _on_body_entered(body) -> void:
	if body is player:
		var Parent = self.get_parent()
		if Parent:
			Parent.modulate.a = 0.1


func _on_body_exited(body) -> void:
	if body is player:
		var Parent = self.get_parent()
		if Parent:
			Parent.modulate.a = 1
