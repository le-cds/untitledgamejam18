extends State


####################################################################################
# Scene Lifecycle

func _ready() -> void:
    $StateMachine/PlayingState.aircraft = $Aircraft

    # If the scene is started directly from the editor for rapid prototyping,
    if self.get_parent() == get_tree().root:
        $StateMachine.transition_push(Constants.GAME_STATE_WAITING)


####################################################################################
# State Lifecycle

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    $StateMachine.transition_push(Constants.GAME_STATE_WAITING)


####################################################################################
# Event Handling

# The player has clicked a Try Again button. We need to instruct the main game's
# state machine to reload the current level.
func _on_try_again() -> void:
    transition_replace_single(Constants.MENU_STATE_LOAD_LEVEL,
        { Constants.MENU_PARAM_LEVEL: Constants.MENU_PARAM_LEVEL_RELOAD })


# The player has clicked a Next Level button. We need to instruct the main game's
# state machine to load the next level, if any.
func _on_next_level() -> void:
    transition_replace_single(Constants.MENU_STATE_LOAD_LEVEL,
        { Constants.MENU_PARAM_LEVEL: Constants.MENU_PARAM_LEVEL_NEXT })