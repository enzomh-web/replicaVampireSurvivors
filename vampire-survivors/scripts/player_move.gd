extends CharacterBody2D

@export_category("Movimentação")
@export var move_speed : float = 80
@export var friction : float = 150
@export var acceleration : float = 250

var char_direction : Vector2

func _physics_process(delta):
	char_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if char_direction != Vector2.ZERO:
		velocity = velocity.move_toward(char_direction * move_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	move_and_slide()
