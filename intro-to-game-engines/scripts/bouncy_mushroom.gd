extends Area2D

func _on_body_entered(body):
	if body.has_method("bounce"):
		body.bounce(-600)
