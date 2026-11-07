extends StaticBody3D

@export var health: float = 100.0
var destroyed := false

func take_damage(amount: float) -> void:
    if destroyed:
        return
    health -= amount
    if health <= 0.0:
        destroyed = true
        queue_free()
