extends Resource
class_name  WeaponData

#@export var name : String
#@export var texture : Texture2D

@export var damage : float
@export var cooldown : float
@export var speed : float

@export var projectile_count : int
@export var projectile_interval : float
@export var projectile_scn : PackedScene = preload("res://scenes/projectile.tscn")
@export var projectile_range : float
