extends Control

@onready var coin_label = $CoinLabel



func _process(_delta):
	coin_label.text = "Coins: %d" % PlayerData.coins

var health_cost := 20
func _on_health_button_pressed():
	if PlayerData.buy_upgrade(health_cost):
		PlayerData.max_health += 1
		health_cost += 10


var attack_cost := 15
func _on_damage_button_pressed():
	if PlayerData.buy_upgrade(attack_cost):
		PlayerData.attack_power += 1
		attack_cost += 15


var speed_cost := 25
func _on_speed_button_pressed():
	if PlayerData.buy_upgrade(speed_cost):
		PlayerData.speed_bonus += 20
		speed_cost += 20


var dash_cost := 30
func _on_dash_button_pressed():
	if PlayerData.buy_upgrade(dash_cost):
		PlayerData.dash_bonus += 50
		dash_cost += 25
