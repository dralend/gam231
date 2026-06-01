extends Node

@export var speed: float = 64.0
@export var jump_force: float = 192.0
@export var gravity: float = 896.0
@export var can_jump: bool = true
@export var can_move: bool = true 

var locked_direction: float = 0.0
var velocity := Vector2.ZERO
var current_gravity: float = 0.0
var horizontal_locked: bool = false
var vertical_locked: bool = false 
var external_push_velocity: float = 0.0
var external_push_timer: float = 0.0
var current_speed: float = 0.0

@onready var player_animated_sprite: AnimatedSprite2D = %PlayerAnimatedSprite

func _ready() -> void:
	current_gravity = gravity
	current_speed = speed 

func apply_movement(input, delta): # Basic movement , gravity, jump ect 
	var player = get_parent()
	velocity = player.velocity
	
	# -------------------------
	# Gravity
	# -------------------------
	if not player.is_on_floor():
		can_jump = false
		velocity.y += current_gravity * delta
	elif player.is_on_floor():
		can_jump = true

# -------------------------
# Horizontal movement
# -------------------------
	if external_push_timer > 0.0:
		external_push_timer -= delta
		velocity.x = external_push_velocity
		
		if external_push_timer <= 0.0:
			external_push_velocity = 0.0
			horizontal_locked = false
			
	elif horizontal_locked:
		velocity.x = 0.0 

	elif player.is_on_floor() and can_move  :
			
		if input.move_input != 0 :
			locked_direction = input.move_input
		else:
			locked_direction = 0
		velocity.x = input.move_input * current_speed
	else: 
		velocity.x = locked_direction * current_speed
				
	# -------------------------
	# Jump
	# -------------------------
	if player.is_on_floor() and input.jump_pressed and can_jump:
		if vertical_locked:
			velocity.y = 0
			
		else:
			if input.left_held:
				locked_direction = -1
			elif input.right_held:
				locked_direction = 1
			else:
				locked_direction = 0
			velocity.y = -jump_force
		
	player.velocity = velocity
	
	# flip sprite we use _lock direction becuse we do not allow air movement
	if locked_direction != 0:
		player_animated_sprite.flip_h = locked_direction <= 0
		
	player.move_and_slide()
	
func apply_external_horizontal_push(force: float, duration: float) -> void:
	external_push_velocity = force
	external_push_timer = duration
	horizontal_locked = true
	
 
	
	
