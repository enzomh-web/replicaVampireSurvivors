extends CharacterBody2D

@export_category("Movimentacao")
@export var move_speed : float
@export var friction : float
@export var acceleration : float

@export_category("Status")
@export var health: float = 100:
	set(value):
		health = value
		%Health.value = value

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
	
	if health <= 0:
		die()

func die() -> void:
	get_tree().call_deferred("reload_current_scene")

func _on_damage_body_entered(body: Node2D) -> void:
	if "damage" in body:
		take_damage(body.damage)

func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled", true)
	%Collision.set_deferred("disabled", false)
