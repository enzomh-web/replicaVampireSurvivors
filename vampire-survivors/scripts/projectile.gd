extends Area2D
class_name Projectile

var _direction : Vector2
var _speed : float
var _damage : float
var _range : float
var _spawn_pos : Vector2

@onready var animated_sprite : AnimatedSprite2D = $Texture

func setup(direction : Vector2, data : WeaponData):
	_direction = direction
	
	if data:
		_speed = data.speed
		_damage = data.damage
		_range = data.projectile_range
		_spawn_pos = global_position
		
		if data.sprite_frames:
			animated_sprite.sprite_frames = data.sprite_frames
		else:
			animated_sprite.sprite_frames = load("res://resources/sprite_frames/placeholder_anim.tres")
		animated_sprite.play("default")
		
	
func _physics_process(delta: float) -> void:
	global_position += _direction * _speed * delta
	if _range > 0.0 and global_position.distance_to(_spawn_pos) >= _range:
		_die()
	
func _on_body_entered(body: Node2D) -> void:
	if body.has_method("take_damage"):
		body.take_damage(_damage)

func _on_screen_exited() -> void:
	_die()

func _die() -> void:
	queue_free()
