extends Area2D
class_name Hurtbox

var parent: Node  # enemy or player that owns this hurtbox

func _ready():
	parent = get_parent()
	area_entered.connect(_on_area_entered)
	print("Hurtbox ready")
	print("Hurtbox parent:", parent)

func _on_area_entered(area: Area2D) -> void:
	print("AREA DETECTED:", area.name)
	print("HURTBOX DETECTED:", area.name)
	if area is Hitbox:
		var hitbox := area as Hitbox
		if parent and parent.has_method("take_damage"):
			parent.take_damage(hitbox.damage, area.global_position)
