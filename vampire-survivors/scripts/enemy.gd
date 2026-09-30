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
		$Sprite2D.texture = value.texture
		damage = value.damage
		health = value.health

func _physics_process(delta):
	direction = (player_reference.position - position).normalized()
	velocity = velocity.move_toward(direction * move_speed, acceleration * delta)

	move_and_slide()
	
func take_damage(amount):
	if health <= 0:
		die()
	
	health -= amount
	
func die() -> void:
	queue_free()
