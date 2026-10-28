extends Area2D

@export var player : PackedScene

# aumenta em 50% o atributo definido posteriormente no código
# temporario
var buff : float = 1.5

func _ready() -> void:
	$Texture.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		colect()

func colect() -> void:
	print("Baú coletado")
	player.health = player.health * buff
	queue_free()
