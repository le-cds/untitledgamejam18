extends State


####################################################################################
# Scene Objects

onready var _aircraft: Aircraft = $Aircraft
onready var _state_machine: StateMachine = $StateMachine
onready var _state_playing: PlayingState = $StateMachine/PlayingState
onready var _state_landed: LandedState = $StateMachine/LandedState


####################################################################################
# Scene Lifecycle

func _ready() -> void:
    _state_playing.aircraft = _aircraft

    # If the scene is started directly from the editor for rapid prototyping,
    if self.get_parent() == get_tree().root:
        _state_machine.transition_push(Constants.GAME_STATE_WAITING)


####################################################################################
# State Lifecycle

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    if params.has(Constants.LEVEL_PARAM_IS_LAST):
        _state_landed.show_next_level_button(not params[Constants.LEVEL_PARAM_IS_LAST])
    
    _state_machine.transition_push(Constants.GAME_STATE_WAITING)


func state_deactivated() -> void:
    .state_deactivated()
    
    # When we are deactivated, that means that either the level is being changed or
    # we're going back to the menu. Unload us!
    if get_parent() is StateMachine:
        (get_parent() as StateMachine).remove_state(self.state_id)
    queue_free()


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


func _on_main_menu() -> void:
    transition_replace_all(Constants.MENU_STATE_MAIN)
