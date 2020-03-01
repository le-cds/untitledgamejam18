extends Node2D


####################################################################################
# Scene Objects

onready var _state_machine: StateMachine = $StateMachine


####################################################################################
# Lifecycle

func start() -> void:
    # As of now, simply load and start the first level. Later on, this should be
    # replaced by a proper menu thing.
    _state_machine.transition_push("level01")
