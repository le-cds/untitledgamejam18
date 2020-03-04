extends Node2D


####################################################################################
# Scene Objects

onready var _state_machine: StateMachine = $StateMachine


####################################################################################
# Lifecycle

func _ready() -> void:
    # Make sure that when this scene is started from the editor, start() is called
    if self.get_parent() == get_tree().root:
        start()


func start() -> void:
    # For now, simply start up the level loader which loads the first level
    _state_machine.transition_push(Constants.MENU_STATE_MAIN)
