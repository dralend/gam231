class_name DamageNumber extends Node2D

@onready var label: Label = $Label

func setup(amount: int) -> void:
	# Ensure label is ready if called immediately after instantiate
	if not label:
		label = $Label
	
	label.text = "-" + str(amount)
	
	# Create tween for floating and fading animation
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	
	# Move up by 50 pixels over 1 second
	tween.tween_property(self, "position:y", position.y - 50.0, 1.0).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	
	# Fade out opacity
	tween.tween_property(self, "modulate:a", 0.0, 1.0).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_CUBIC)
	
	# When animation finishes, delete this node
	tween.chain().tween_callback(queue_free)
