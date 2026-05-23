extends CharacterBody2D
class_name player

const SPEED = 120.0
const JUMP_VELOCITY = -300.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var double_jump: bool = false



func _physics_process(delta: float) -> void:
	if is_on_floor() and double_jump == true:
		double_jump = false
	if not is_on_floor():
		velocity += get_gravity() * delta
	var direction := Input.get_axis("move_left", "move_right")
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			jump()
		elif double_jump == false:
			double_jump = true
			jump()
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle")
		else :
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	move_and_slide()


func jump(multi : float = 1):
		velocity.y = JUMP_VELOCITY * multi
