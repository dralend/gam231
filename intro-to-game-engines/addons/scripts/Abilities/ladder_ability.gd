extends Node

@export var climb_speed: float = 150.0
@export var descend_speed: float = 150.0
@export var jump_off_ladder_force: float = 300.0
@export var jump_off_ladder_horizontal: float = 300.0
@export var horizontal_push_time: float = 0.3

# --- PUBLIC STATE ---
var on_ladder: bool = false
var ignore_gravity: bool = false
var ladder_gravity: float = 0.0

# --- INTERNAL STATE ---
var in_ladder_area: bool = false
var _current_ladder: Area2D = null
var _ladder_center_x: float = 0.0
var _snapped_to_ladder: bool = false
const ZERO_SPEED : float = 0.0

# ---------------------------------------------------
# CONNECT TO ALL LADDERS
# ---------------------------------------------------
func _ready() -> void:
	for ladder in get_tree().get_nodes_in_group("ladders"):
		ladder.ladder_entered.connect(_on_ladder_entered)
		ladder.ladder_exited.connect(_on_ladder_exited)

# ---------------------------------------------------
# LADDER SIGNALS
# ---------------------------------------------------
func _on_ladder_entered(ladder: Area2D) -> void:
	_current_ladder = ladder
	in_ladder_area = true
	_ladder_center_x = ladder.global_position.x

func _on_ladder_exited(ladder: Area2D) -> void:
	if ladder != _current_ladder:
		return

	_exit_ladder_state()

# ---------------------------------------------------
# MAIN ABILITY
# ---------------------------------------------------
func process_ability(input) -> void:
	var player = get_parent().player_composed
	var movement = get_parent().movement_controller

	# ENTER LADDER (intent-based)
	if in_ladder_area and not on_ladder:
		if input.up_pressed or input.down_pressed:
			on_ladder = true
			_snapped_to_ladder = false
			

	# GRAVITY CONTROL
	ignore_gravity = on_ladder
	movement.current_gravity = ladder_gravity if on_ladder else movement.gravity

	# EARLY EXIT IF NOT CLIMBING
	if not on_ladder:
		return

	# SNAP TO LADDER (AIR ONLY)
	if not _snapped_to_ladder and not player.is_on_floor():
		player.global_position.x = _ladder_center_x
		_snapped_to_ladder = true
		movement.current_speed = ZERO_SPEED

	# RELEASE HORIZONTAL LOCK WHEN PLAYER LEAVES LADDER OR FLOOR
	if player.is_on_floor() or _reached_top_of_ladder(player):
		_snapped_to_ladder = false
		on_ladder = false
		ignore_gravity = false
		movement.current_speed = movement.speed

	# JUMP OFF LADDER (ONLY WITH DIRECTION)
	if input.jump_pressed and input.move_input != 0:
		_leave_ladder(player, movement, input.move_input)
		return

	# CLIMBING
	if input.up_pressed:
		player.velocity.y = -climb_speed
	elif input.down_pressed:
		player.velocity.y = descend_speed
	else:
		player.velocity.y = 0
# ---------------------------------------------------
# LEAVE LADDER
# ---------------------------------------------------
func _leave_ladder(player, movement, direction: float) -> void:
	_exit_ladder_state()

	player.velocity.y = -jump_off_ladder_force
	movement.apply_external_horizontal_push(
		direction * jump_off_ladder_horizontal,
		horizontal_push_time
	)
# ---------------------------------------------------
# RESET LADDER STATE
# ---------------------------------------------------
func _exit_ladder_state() -> void:
	var movement = get_parent().movement_controller
	on_ladder = false
	_snapped_to_ladder = false
	in_ladder_area = false
	_current_ladder = null
	ignore_gravity = false
	movement.current_speed = movement.speed
# ---------------------------------------------------
# HELPER: CHECK TOP OF LADDER
# ---------------------------------------------------
func _reached_top_of_ladder(player) -> bool:
	if _current_ladder == null:
		return false
	# Assume the ladder's top is its global y position minus half its height
	var shape = _current_ladder.shape_owner_get_shape(0, 0)
	var ladder_top = _current_ladder.global_position.y - (shape.size.y / 2)
	return player.global_position.y <= ladder_top
