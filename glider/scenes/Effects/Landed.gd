extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
    $Particles.emitting = true


func _on_Timer_timeout() -> void:
    # Enough with the particles already!
    queue_free()
