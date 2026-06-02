extends Node2D
class_name Enemys 

const SPEED = 60

var direction = 1
var is_dead := false


@onready var ray_castright: RayCast2D = $RayCastright
@onready var ray_castleft: RayCast2D = $RayCastleft
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var Max_Health: int = 1
var Current_Health: int

func _ready() -> void:
	Current_Health = Max_Health
	add_to_group("enemy")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if ray_castright. is_colliding():
		direction = -1
		animated_sprite_2d.flip_h = true
	if ray_castleft. is_colliding():
		direction = 1
		animated_sprite_2d.flip_h = false
	
	position.x += direction * SPEED * delta

func die() -> void:
	animated_sprite_2d.play("dead")
	queue_free()

func take_damage(damage: int):
	print("Enemy took", damage, "damage")
	Current_Health -= damage

	if Current_Health <= 0:
		die()
