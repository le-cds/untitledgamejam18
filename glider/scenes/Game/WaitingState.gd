extends State

# This is the state a level starts out with. Once started, this state waits for the player
# to issue the game start action and then switches to the playing state.
class_name WaitingState


####################################################################################
# State

# The aircraft we have spawned.
var _aircraft: Aircraft


####################################################################################
# Scene Lifecycle

func _physics_process(delta: float) -> void:
    if is_running():
        if Input.is_action_just_pressed("game_start"):
            var params = {
                Constants.GAME_PARAM_AIRCRAFT: _aircraft
            }
            transition_replace_single(Constants.GAME_STATE_PLAYING, params)

        elif Input.is_action_just_pressed("game_pause"):
            transition_push(Constants.GAME_STATE_PAUSED)


####################################################################################
# State Lifecycle

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    # Spawn a new aircraft, ready to be passed on to the playing state
    var spawner: AircraftSpawner = params[Constants.GAME_PARAM_AIRCRAFT_SPAWNER]
    _aircraft = spawner.spawn()

    # Setup the aircraft with an input controller
    var controller := PlayerInputController.new()
    _aircraft.add_child(controller)
    _aircraft.set_input_controller(controller)


func state_paused(next_state: State) -> void:
    .state_paused(next_state)

    # Clean up our reference to the aircraft
    _aircraft = null
