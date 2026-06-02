extends CharacterBody2D
class_name Player 

@export var SPEED: float = 200.0
@export var JUMP_VELOCITY: float = -300.0
@export var acceleration: float = 800
@export var wall_speed: float = 300
@export var dash_speed: float = 425
@export var friction: float = 1100
@export var air_resistance: float = 225

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

@export var Max_Health: int = 6
var Current_Health: int

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_air_dash: bool = false
var can_double_jump: bool = true
var can_wall_jump: bool = true

func _ready() -> void:
	Current_Health = Max_Health
	add_to_group("Player")

func _physics_process(delta: float) -> void:
	handle_gravity(delta)
	handle_jump()
	handle_air_dash()
	handle_double_jump()
	handle_wall_jump()


	var input_vector: Vector2 = Vector2.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	handle_move(input_vector, delta)
	update_facing_direction(input_vector.x)
	
	move_and_slide()

# Handle movment
func handle_move(input_vector: Vector2, delta: float) -> void:
	if input_vector.x != 0:
		velocity.x = move_toward(velocity.x, SPEED * input_vector.x, acceleration * delta)
		if is_on_floor():
			animated_sprite.play("run")
		else:
			animated_sprite.play("jump")
	elif input_vector.x == 0 and not is_on_floor():
		animated_sprite.play("jump")
		velocity.y = move_toward(velocity.x, 0, air_resistance * delta)
	else :
		animated_sprite.play("idle")
		can_double_jump = true
		can_wall_jump = true
		velocity.x = move_toward(velocity.x, 0, friction * delta)

# update the direction
func update_facing_direction(direction: float) -> void:
	if sign(direction) == -1:
		animated_sprite.flip_h = true
	elif sign(direction) == 1:
		animated_sprite.flip_h = false

# Add the gravity.
func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

# Handle jump
func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		can_air_dash = true

func handle_double_jump() -> void:
	if can_double_jump and Input.is_action_just_pressed("jump") and not is_on_floor():
		can_double_jump = false
		velocity.y = JUMP_VELOCITY * 1.1

# Wall jump
func handle_wall_jump() -> void:
	if can_wall_jump and Input.is_action_just_pressed("jump") and is_on_wall_only():
		var wall_normal: Vector2 = get_wall_normal()
		can_wall_jump = false
		velocity.x = wall_normal.x * wall_speed
		velocity.y = JUMP_VELOCITY * 1.1


# Handle air dash
func handle_air_dash() -> void:
	var direction: float = Input.get_axis("move_left", "move_right")

	if Input.is_action_just_pressed("dash") and can_air_dash and not is_on_floor():
		can_air_dash = false
		velocity.x = direction * dash_speed
		velocity.y = JUMP_VELOCITY * 0.6
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true

func take_damage(damage: int):
	print("Player hit for", damage)
	Current_Health -= damage
	print("Health:", Current_Health)
