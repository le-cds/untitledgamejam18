extends State


func _ready() -> void:
    $StateMachine/PlayingState.aircraft = $Aircraft

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    $StateMachine.transition_push(Constants.GAME_STATE_WAITING)
