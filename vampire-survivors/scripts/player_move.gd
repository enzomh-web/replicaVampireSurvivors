extends CharacterBody2D

@export_category("Movimentacao")
@export var move_speed : float
@export var friction : float
@export var acceleration : float

@export_category("Status")
@export var health: float

var char_direction : Vector2

func _physics_process(delta):
	char_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if char_direction != Vector2.ZERO:
		velocity = velocity.move_toward(char_direction * move_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	move_and_slide()

func take_damage(amount):
	health -= amount
	print(amount)

#func _on_damage_body_entered(body: Node2D) -> void:
	#take_damage(body.damage)
