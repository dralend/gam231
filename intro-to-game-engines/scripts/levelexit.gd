extends Area2D


@export var transition_type: String
@export var next_scene: String
@export var duration: float

var player_can_enter: bool = false

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)
	

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("enter_door"):
		if player_can_enter == true:
			Scenetrancontroller.change_scene(next_scene, transition_type, duration)

func _on_body_entered(body: Node2D) -> void:
	if body:
		player_can_enter = true

func _on_body_exited(body: Node2D) -> void:
	if body:
		player_can_enter = false
