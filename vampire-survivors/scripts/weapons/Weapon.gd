extends Node2D
class_name Weapon

enum State { READY, FIRING, RELOADING }
@export var data : WeaponData

var _state : State = State.READY
var _shots_fired : int = 0
@onready var _timer : Timer = Timer.new()

func _ready() -> void:
	add_child(_timer)
	_timer.one_shot = true
	_timer.timeout.connect(_on_timer_timeout)
	_start_burst()

func _start_burst() -> void:
	_state = State.FIRING
	_shots_fired = 0
	_fire_next_shot()

func _fire_next_shot() -> void:
	var angle = _get_angle(_shots_fired)
	_spawn_projectile(angle)
	_shots_fired += 1
	
	if _shots_fired >= data.projectile_count:
		_state = State.RELOADING
		_timer.start(data.cooldown)
	else:
		_timer.start(data.projectile_interval)

func _on_timer_timeout() -> void:
	match  _state:
		State.FIRING:
			_fire_next_shot()
		State.RELOADING:
			_start_burst()

func _get_angle(index : int) -> float:
	var angle_step := TAU / data.projectile_count
	return index * angle_step



func _spawn_projectile(angle : float) -> void:
	var direction := Vector2.RIGHT.rotated(angle)
	
	var projectile := data.projectile_scn.instantiate() as Projectile
	get_tree().current_scene.add_child.call_deferred(projectile)
	projectile.global_position = global_position
	projectile.setup(direction, data)
