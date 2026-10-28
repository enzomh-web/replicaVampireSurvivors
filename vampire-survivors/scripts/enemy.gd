extends CharacterBody2D

@export_category("Movimentacao")
@export var move_speed: float
#@export var friction: float
@export var acceleration: float

@export_category("Referencias")
@export var player_reference: CharacterBody2D
var loot_box: PackedScene = load("res://scenes/loot_box.tscn")

@onready var texture: AnimatedSprite2D = $Texture

var direction: Vector2
var damage: float
var health: float


var is_boss: bool = false:
	set(value):
		is_boss = value
		if value:
			var outline = load("res://shaders/outline.tres")
			$Texture.material = outline.duplicate()
			$Texture.material.set_shader_parameter("outline_color", type.boss_outline_color)

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
	
	if direction.x != 0:
		texture.flip_h = (direction.x > 0)

	move_and_slide()
	
func take_damage(amount):
	health -= amount
	
	if health <= 0:
		die()
	
func die() -> void:
	if is_boss:
		spawn_loot_box()
		
	queue_free()

func spawn_loot_box() -> void:
	if loot_box:
		var box_instance = loot_box.instantiate()
		get_parent().call_deferred("add_child", box_instance)
		box_instance.global_position = global_position
