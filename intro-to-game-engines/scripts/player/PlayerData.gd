extends Node

const SAVE_PATH = "user://save.dat"

var coins: int = 0

var max_health: int = 6
var attack_power: int = 1
var speed_bonus: float = 0.0
var dash_bonus: float = 0.0

func _ready():
	load_data()

func buy_upgrade(cost: int) -> bool:
	if coins >= cost:
		coins -= cost
		PlayerData.save_data()
		return true
	return false


func save_data():
	var save_dict = {"coins": coins, "max_health": max_health, "attack_power": attack_power, "speed_bonus": speed_bonus, "dash_bonus": dash_bonus}
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var(save_dict)


func load_data():

	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var data = file.get_var()
	coins = data["coins"]
	max_health = data["max_health"]
	attack_power = data["attack_power"]
	speed_bonus = data["speed_bonus"]
	dash_bonus = data["dash_bonus"]
