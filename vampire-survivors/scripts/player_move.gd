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
@export var is_invincible: bool = false

@onready var sprite : Sprite2D = $Sprite
@onready var anim_player : AnimationPlayer = $AnimationPlayer

var char_direction : Vector2
var last_char_direction : Vector2

func _physics_process(delta):
	char_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if char_direction != Vector2.ZERO:
		velocity = velocity.move_toward(char_direction * move_speed, acceleration * delta)
		last_char_direction = Vector2(
			char_direction.x if char_direction.x != 0 else last_char_direction.x,
			char_direction.y if char_direction.y != 0 else last_char_direction.y)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
		
	move_and_slide()
	_update_animation()

func take_damage(amount):
	if not is_invincible:
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

func _update_animation() -> void:
	var is_moving_x : bool = (char_direction.x != 0)
	var is_moving : bool = (char_direction != Vector2.ZERO)
	var dir_x := char_direction.x if is_moving_x else last_char_direction.x
	var state := "walk" if is_moving else "idle"
	var side := "left" if dir_x < 0 else "right"
	_play_anim_safe("%s_%s" % [state, side])
			
func _play_anim_safe(anim_name : String) -> void:
	if not anim_player.has_animation(anim_name):
		push_warning("Animacao '%s' nao encontrada no node AnimationPlayer" % anim_name)
		return
	if anim_player.current_animation != anim_name:
		anim_player.play(anim_name)
