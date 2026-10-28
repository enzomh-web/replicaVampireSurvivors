extends Node2D

@export_category("Referencias")
@export var player: CharacterBody2D
@export var enemy: PackedScene

@export_category("Wave")
@export var waves: Array[Wave]

@export_category("Spawn")
@export var spawn_distance: float = 500

var wave_index: int = 0
var current_wave: Wave
var elapsed_in_wave: int = 0
var boss_spawned: bool = false

@onready var density_timer : Timer = %DensityTimer

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


func _ready() -> void:
	start_wave(0)

func start_wave(index: int) -> void:
	wave_index = clampi(index, 0, waves.size() - 1)
	current_wave = waves[wave_index]

	elapsed_in_wave = 0
	boss_spawned = false

	density_timer.stop()
	
	density_timer.wait_time = maxf(current_wave.density, 0.1)
	density_timer.start()
	
func get_enemy() -> Enemy:
	var enemies := current_wave.wave_enemies
	var proportions := current_wave.proportion
	
	var roll := randf()
	var cumulative := 0.0

	for i in range(enemies.size()):
		cumulative += proportions[i]

		if roll < cumulative:
			return enemies[i]

	return enemies.back() if proportions.back() >= 1.0 else null

func spawn_enemy(enemy_type: Enemy) -> void:
	var enemy_instance = enemy.instantiate()

	enemy_instance.type = enemy_type
	enemy_instance.player_reference = player
	enemy_instance.is_boss = enemy_type.is_boss

	get_tree().current_scene.add_child(enemy_instance)
	enemy_instance.global_position = get_random_pos()

func get_random_pos() -> Vector2:
	return player.global_position + spawn_distance * Vector2.RIGHT.rotated(randf_range(0.0, TAU))

func _on_timer_timeout() -> void:
	second += 1
	elapsed_in_wave +=1
	
	if elapsed_in_wave >= 60:
		if wave_index < waves.size() - 1:
			start_wave(wave_index + 1)
		return
	
	if current_wave.boss != null and not boss_spawned:
		if elapsed_in_wave >= current_wave.boss_apparition:
			boss_spawned = true
			spawn_enemy(current_wave.boss)

func _on_density_timer_timeout() -> void:
	var selected_enemy := get_enemy()

	if selected_enemy != null:
		spawn_enemy(selected_enemy)
