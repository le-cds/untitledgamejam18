extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
    var children = get_children()
    for child in children:
        child.frame = randi() % child.hframes


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#    pass
