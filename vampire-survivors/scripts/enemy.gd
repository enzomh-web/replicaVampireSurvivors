extends CharacterBody2D

@export_category("Movimentacao")
@export var move_speed: float
#@export var friction: float
@export var acceleration: float

@export_category("Referencias")
@export var player_reference: CharacterBody2D

var direction: Vector2
var damage: float
var health: float

var type: Enemy:
	set(value):
		type = value
		if value.sprite_frames:
			$Texture.sprite_frames = value.sprite_frames
		else:
			$Texture.sprite_frames = load("res://resources/sprite_frames/placeholder_anim.tres")
		$Texture.play("default")
		
		damage = value.damage
		health = value.health

func _physics_process(delta):
	direction = (player_reference.position - position).normalized()
	velocity = velocity.move_toward(direction * move_speed, acceleration * delta)

	move_and_slide()
	
func take_damage(amount):
	health -= amount
	
	if health <= 0:
		die()
	
func die() -> void:
	
	queue_free()
