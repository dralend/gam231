extends  Node

# --- PUBLIC STATE ---
var is_in_doorway: bool = false 
var is_hidden_in_doorway: bool = false 

# --- INTERNAL STATE ---
var _current_doorway: Area2D = null
var _doorway_center_x: float = 0.0
var _snapped_to_doorway: bool = false

# ---------------------------------------------------
# CONNECT TO ALL DOORWAYS
# ---------------------------------------------------
func _ready() -> void:
	for doorway in get_tree().get_nodes_in_group("doorway"):
		doorway.doorway_entered.connect(_on_doorway_entered)
		doorway.doorway_exited.connect(_on_doorway_exited)

func _on_doorway_entered(doorway: Area2D) -> void:
	_current_doorway = doorway
	is_in_doorway = true
	_doorway_center_x = doorway.global_position.x
	_snapped_to_doorway = true

func _on_doorway_exited(doorway: Area2D) -> void:
	if doorway != _current_doorway:
		return 
	_door_exited()

func _door_exited() -> void:
	is_in_doorway = false
	is_hidden_in_doorway = false
	_snapped_to_doorway = false

# ---------------------------------------------------
# MAIN ABILITY
# ---------------------------------------------------
func process_ability(input):
	var player_composed = get_parent().player_composed
	var movement_controller = get_parent().movement_controller
	
	if is_in_doorway and input.up_pressed:
		movement_controller.horizontal_locked = true
		movement_controller.vertical_locked = true 
		is_hidden_in_doorway = true
		if not _snapped_to_doorway:
			player_composed.global_position.x = _doorway_center_x
			_snapped_to_doorway = true
	else:
		is_hidden_in_doorway = false
		_snapped_to_doorway = false
		movement_controller.horizontal_locked = false
		movement_controller.vertical_locked = false
		
		
	
	
	
