extends Area2D

func _ready() -> void:
	$Texture.play("default")

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		print("Peguei bau")
		queue_free()
