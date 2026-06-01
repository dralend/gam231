extends CanvasLayer

signal transition_half_completed(target_scene:String)
signal transition_completed

var current_transition: Node = null
var is_transitioning: bool = false

func change_scene(target_scene: String, transition_type: String = "fade", duration: float = 1.0):
	if is_transitioning:
		return
		
	is_transitioning = true
	
	var transition_scene: Node = null
	
	match transition_type:
		"fade":
			transition_scene = load("res://scenes/ui/level_transition/fade.tscn").instantiate()
		_:
			transition_scene = load("res://scenes/ui/level_transition/fade.tscn").instantiate()
	
	transition_scene.duration = duration
	
	transition_half_completed.connect(_on_transition_half_completed)
	transition_completed.connect(_on_transition_completed)
	
	add_child(transition_scene)
	current_transition = transition_scene
	
	transition_scene.transition_in(target_scene)
	

func _on_transition_half_completed(target_scene: String):
	get_tree().change_scene_to_file(target_scene)

func _on_transition_completed():
	if current_transition:
		current_transition.queue_free()
		current_transition = null
		
		transition_half_completed.disconnect(_on_transition_half_completed)
		transition_completed.disconnect(_on_transition_completed)
	
	is_transitioning = false
