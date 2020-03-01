extends Node2D


onready var _state_machine: StateMachine = $StateMachine


func start() -> void:
    _state_machine.transition_push("level01")
