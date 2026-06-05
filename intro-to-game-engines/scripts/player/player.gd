extends CharacterBody2D
class_name Player 

enum State {IDLE, RUN, JUMP, DASH, ATTACK, BLOCK, HIT, DEAD}
var state = State.IDLE

@export var SPEED = 200.0
@export var JUMP_FORCE = -300.0
@export var DASH_SPEED = 500.0
@export var WALL_JUMP_SPEED = 300.0
@export var MAX_HEALTH = 6
@export var base_damage: int = 1


var total_damage: int
var current_health: int
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var can_double_jump = true
var can_air_dash = true
var invincible = false
var blocking = false
var dying = false

var knockback_velocity = Vector2.ZERO

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox_light: Hitbox = $hitbox_light
@onready var invincibility_timer: Timer = $Invincibility_timer
@onready var dash_timer: Timer = $Dash_timer
@onready var death_timer: Timer = $Death_timer


func _ready():
	hitbox_light.monitoring = false
	invincibility_timer.timeout.connect(_on_invincibility_timeout)
	dash_timer.timeout.connect(_on_dash_timeout)
	death_timer.timeout.connect(_on_death_timeout)
	current_health = PlayerData.max_health
	SPEED += PlayerData.speed_bonus
	DASH_SPEED += PlayerData.dash_bonus
	total_damage = base_damage + PlayerData.attack_power
	animated_sprite_2d.animation_finished.connect(_on_animation_finished)


func _physics_process(delta) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	if is_on_floor():
		can_double_jump = true
		can_air_dash = true
	handle_movement(delta)
	jump()
	handle_wall_jump()
	dash()
	light_attack()
	heavy_attack()
	block()

	if knockback_velocity.length() > 0:
		velocity += knockback_velocity
		knockback_velocity = knockback_velocity.move_toward(Vector2.ZERO, 800 * delta)
	update_animation()
	move_and_slide()


func handle_movement(delta):
	var direction = Input.get_axis( "move_left", "move_right")
	if direction != 0:
		velocity.x = move_toward(velocity.x, direction * SPEED, 800 * delta)

		# flip sprite
		animated_sprite_2d.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0, 1100 * delta)

func jump(force = JUMP_FORCE):
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = JUMP_FORCE
			can_air_dash = true
		elif can_double_jump:
			can_double_jump = false
			velocity.y = JUMP_FORCE


func handle_wall_jump():
	if Input.is_action_just_pressed("jump") and is_on_wall_only():
		var normal = get_wall_normal()
		velocity.x = normal.x * WALL_JUMP_SPEED
		velocity.y = JUMP_FORCE


func dash():
	if Input.is_action_just_pressed("dash"):
		if is_on_floor():
			state = State.DASH
		elif can_air_dash:
			can_air_dash = false
			state = State.DASH
		var dir = Input.get_axis("move_left", "move_right")
		if dir == 0:
			dir = -1 if animated_sprite_2d.flip_h else 1
		velocity.x = dir * DASH_SPEED
		dash_timer.start()


func _on_dash_timeout():
	if state == State.DASH:
		state = State.IDLE


func light_attack():
	if Input.is_action_just_pressed("attack"):
		state = State.ATTACK
		animated_sprite_2d.play("attack_light")
		hitbox_light.monitoring = true
		await get_tree().create_timer(0.15).timeout
		hitbox_light.monitoring = false


func _on_animation_finished():
	if animated_sprite_2d.animation == "attack_light":
		state = State.IDLE


func heavy_attack():
	if Input.is_action_just_pressed("heavy_attack"):
		state = State.ATTACK
		animated_sprite_2d.play("attack_heavy")
		hitbox_light.monitoring = true
		await get_tree().create_timer(0.25).timeout
		hitbox_light.monitoring = false


func block():
	blocking = Input.is_action_pressed("block")
	if blocking:
		state = State.BLOCK
	elif state == State.BLOCK:
		state = State.IDLE


func take_damage(damage: int, hit_position: Vector2, knockback_force: float):
	if invincible:
		return
	if blocking:
		damage = int(ceil(damage * 0.5))
		knockback_force *= 0.25
	print("PLAYER TOOK DAMAGE")
	current_health -= damage
	animated_sprite_2d.play("hit")
	state = State.HIT
	var direction = (global_position - hit_position).normalized()
	direction.y = -0.4
	knockback_velocity = (direction.normalized() * knockback_force)
	start_Invincibility_timer()

	if current_health <= 0:
		die()


func start_Invincibility_timer():
	invincible = true
	animated_sprite_2d.modulate.a = 0.5
	invincibility_timer.start()


func _on_invincibility_timeout():
	invincible = false
	animated_sprite_2d.modulate.a = 1.0
	if state == State.HIT:
		state = State.IDLE


func die():
	if dying:
		return
	dying = true
	state = State.DEAD
	set_physics_process(false)
	animated_sprite_2d.play("dead")
	death_timer.start()


func _on_death_timeout():
	queue_free()


func update_animation():
	if dying:
		return
	if state == State.BLOCK:
		animated_sprite_2d.play("block")
		return
	if state == State.HIT:
		animated_sprite_2d.play("hit")
		return
	if state == State.ATTACK:
		return
	if not is_on_floor():
		animated_sprite_2d.play("jump")
		return
	if abs(velocity.x) > 5:
		animated_sprite_2d.play("run")
	else:
		animated_sprite_2d.play("idle")
