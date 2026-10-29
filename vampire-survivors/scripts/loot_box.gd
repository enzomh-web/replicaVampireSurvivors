extends Area2D

# aumenta em 50% o atributo definido posteriormente no código
# temporario
var buff_percentage : float = 50.00
var invincible_time : float = 5.0

var was_collected : bool = false

func _ready() -> void:
	$Texture.play("default")
	

func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group("Player"):
		return
	
	colect(body)

func colect(player : Node2D) -> void:
	if was_collected:
		return
	
	was_collected = true
	print("Baú coletado")
	
	$Texture.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	
	apply_buf(player)
	#queue_free()

func apply_buf(player : Node2D) -> void:
	var multiplier : float = 1.00 + buff_percentage / 100.00
	var original_material = player.get_node("Sprite").material
	
	player.get_node("Sprite").material = load("res://shaders/outline.tres")
	player.health *= multiplier
	player.is_invincible = true
	
	print("A propriedade Health foi aumentada em %.2f%% e o player ficou invencivel por %.1fs" % [buff_percentage, invincible_time])
	
	await get_tree().create_timer(invincible_time, true).timeout
	
	player.is_invincible = false
	player.get_node("Sprite").material = original_material
	
	print("A invencibilidade acabou")
	
	die()
	
func die():
	queue_free()
