extends CharacterBody2D
class_name Enemy

enum State {IDLE, CHASE, ATTACK, DEAD}

@export var move_speed: float = 80.0
@export var attack_range: float = 40.0
@export var detection_range: float = 200.0
@export var max_health: int = 1
@export var attack_damage: int = 1

var current_health: int
var state: State = State.IDLE
var player: Player = null
var is_dead := false
var can_attack := true

@onready var hitbox: Hitbox = $hitbox
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var attack_cooldown: Timer = $AttackCooldown

func _ready():
	current_health = max_health
	add_to_group("enemy")
	animated_sprite.animation_finished.connect(_on_animation_finished)
	attack_cooldown.timeout.connect(_on_attack_cooldown_timeout)
	hitbox.monitoring = false

func _physics_process(_delta):
	if is_dead:
		return
	find_player()
	match state:
		State.IDLE:
			idle_state()
		State.CHASE:
			chase_state()
		State.ATTACK:
			attack_state()

	move_and_slide()
	update_animation()

func find_player():
	if player == null:
		player = get_tree().get_first_node_in_group("player")


func idle_state():
	velocity.x = 0
	if player == null:
		return
	var distance = global_position.distance_to(player.global_position)
	if distance <= detection_range:
		state = State.CHASE

func chase_state():
	if player == null:
		state = State.IDLE
		return
	var distance = global_position.distance_to(player.global_position)
	if distance > detection_range:
		state = State.IDLE
		return
	if distance <= attack_range:
		state = State.ATTACK
		return
	var direction = sign(player.global_position.x - global_position.x)
	velocity.x = direction * move_speed
	animated_sprite.flip_h = direction < 0

func attack_state():
	velocity.x = 0
	if player == null:
		state = State.IDLE
		return
	var distance = global_position.distance_to(player.global_position)
	if distance > attack_range:
		state = State.CHASE
		return
	if can_attack:
		can_attack = false
		animated_sprite.play("attack")
		await get_tree().create_timer(0.2).timeout
		hitbox.monitoring = true
		await get_tree().create_timer(0.15).timeout
		hitbox.monitoring = false
		attack_cooldown.start()

func take_damage(damage: int, _hit_position: Vector2 = Vector2.ZERO, _knockback_force: float = 0.0):
	if is_dead:
		return
	current_health -= damage
	print("Enemy HP:", current_health)
	if current_health <= 0:
		die()

func die():
	if is_dead:
		return
	is_dead = true
	state = State.DEAD
	velocity = Vector2.ZERO
	animated_sprite.play("dead")

func _on_animation_finished():
	if is_dead and animated_sprite.animation == "dead":
		queue_free()

func _on_attack_cooldown_timeout():
	can_attack = true
	if not is_dead:
		state = State.CHASE

func update_animation():
	if is_dead:
		return
	match state:
		State.IDLE:
			if animated_sprite.animation != "idle":
				animated_sprite.play("idle")
		State.CHASE:
			if animated_sprite.animation != "run":
				animated_sprite.play("run")
		State.ATTACK:
			pass
