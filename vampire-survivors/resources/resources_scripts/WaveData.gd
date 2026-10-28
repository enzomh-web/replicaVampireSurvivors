extends Resource
class_name Wave

@export var wave_enemies : Array[Enemy]
@export var proportion : Array[float]
@export_range(0.01, 1.0, 0.1, "or_greater") var density : float
@export var boss : Enemy
@export_range(0, 60, 5) var boss_apparition : int
