extends State


func _ready() -> void:
    $StateMachine/PlayingState.aircraft = $Aircraft

    if self.get_parent() == get_tree().root:
        $StateMachine.transition_push(Constants.GAME_STATE_WAITING)

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    $StateMachine.transition_push(Constants.GAME_STATE_WAITING)
