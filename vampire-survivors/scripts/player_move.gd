extends CharacterBody2D

@export var moveSpeed : float = 500
var charDirection : Vector2

func _physics_process(delta):
	charDirection.x = Input.get_axis("move_left", "move_right")
	charDirection.y = Input.get_axis("move_up", "move_down")
	
	if charDirection:
		velocity = charDirection * moveSpeed
	else:
		velocity = velocity.move_toward(Vector2.ZERO, moveSpeed)
	
	move_and_slide()
