extends Node2D

@export_category("Referencias")
@export var player: CharacterBody2D
@export var enemy: PackedScene

var spawn_distance: float = 500

@export var enemy_types: Array[Enemy]

var minute: int:
	set(value):
		minute = value
		if minute <= 9:
			%Minute.text = "0" + str(value)
		else:
			%Minute.text = str(value)

var second: int:
	set(value):
		second = value
		if second >= 60:
			second -= 60
			minute += 1
		%Second.text = str(second).lpad(2, '0')

func spawn(pos: Vector2):
	var enemy_instance = enemy.instantiate()
	
	enemy_instance.type = enemy_types[0] # futura logica de waves aqui
	
	enemy_instance.position = pos
	enemy_instance.player_reference = player
	
	get_tree().current_scene.add_child(enemy_instance)
	

func get_random_pos() -> Vector2:
	return player.position + spawn_distance * Vector2.RIGHT.rotated(randf_range(0, 2 * PI))

func amount(num: int = 1):
	for i in range(num):
		spawn(get_random_pos())

func _on_timer_timeout() -> void:
	second += 1
	amount(minute + 1)
