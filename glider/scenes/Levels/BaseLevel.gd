extends State


####################################################################################
# Scene Objects

onready var _animation := $AnimationPlayer
onready var _aircraft_spawner := $AircraftSpawner
onready var _state_machine := $StateMachine
onready var _state_playing := $StateMachine/PlayingState
onready var _state_landed := $StateMachine/LandedState


####################################################################################
# Scene Lifecycle

func _ready() -> void:
    set_yield_on_pause(true)

    # If the scene is started directly from the editor for rapid prototyping,
    if self.get_parent() == get_tree().root:
        _start_new_game()


####################################################################################
# State Lifecycle

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    if params.has(Constants.LEVEL_PARAM_IS_LAST):
        _state_landed.show_next_level_button(not params[Constants.LEVEL_PARAM_IS_LAST])

    _animation.play_backwards("Fade")

    _start_new_game()


func state_paused(next_state: State) -> void:
    .state_paused(next_state)

    # Fade out
    _animation.play("Fade")
    yield(_animation, "animation_finished")


func state_deactivated() -> void:
    .state_deactivated()

    # Ensure that our state machine properly exits
    _state_machine.transition_pop_to_root()

    # When we are deactivated, that means that either the level is being changed or
    # we're going back to the menu. Unload us!
    if get_parent() is StateMachine:
        (get_parent() as StateMachine).remove_state(self.state_id)
    queue_free()


####################################################################################
# Game Handling

func _start_new_game() -> void:
    var params = {
        Constants.GAME_PARAM_AIRCRAFT_SPAWNER: _aircraft_spawner
    }
    _state_machine.transition_replace_all(Constants.GAME_STATE_WAITING, params)


####################################################################################
# Event Handling

# The player has clicked a Try Again button. We need to instruct the main game's
# state machine to reload the current level.
func _on_try_again() -> void:
    _start_new_game()


# The player has clicked a Next Level button. We need to instruct the main game's
# state machine to load the next level, if any.
func _on_next_level() -> void:
    transition_replace_single(Constants.MENU_STATE_LOAD_LEVEL,
        { Constants.MENU_PARAM_LEVEL: Constants.MENU_PARAM_LEVEL_NEXT })


# The player has clicked the Main Menu button, so take them back to the menu.
func _on_main_menu() -> void:
    transition_replace_all(Constants.MENU_STATE_MAIN)
