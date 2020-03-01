extends State

# The playing state tells the plane to start flying,
class_name PlayingState


####################################################################################
# Scene Objects

onready var _hud: HUD = $HUD
onready var _animation: AnimationPlayer = $AnimationPlayer


####################################################################################
# State

var aircraft: Aircraft setget set_aircraft


####################################################################################
# State Lifecycle

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    # Start up everything
    aircraft.start()
    _hud.set_timer_running(true)

    # Fade in the HUD
    _animation.play("FadeHUD")


func state_paused(next_state: State) -> void:
    # Fade out the HUD
    _animation.play_backwards("FadeHUD")


####################################################################################
# Accessors

func set_aircraft(craft: Aircraft) -> void:
    aircraft = craft
    aircraft.connect("stopped_flying", self, "_on_aircraft_stopped_flying")


####################################################################################
# Signal Handlers

func _on_aircraft_stopped_flying(reason) -> void:
    # Stop the timer before we decide what we should actually do
    _hud.set_timer_running(false)

    match reason:
        Aircraft.State.LANDED:
            var params = { LandedState.PARAMS_TIME: _hud.get_timer() }
            transition_push(Constants.GAME_STATE_LANDED, params)

        Aircraft.State.EXPLODED:
            print("Exploded")

        Aircraft.State.LEFT:
            print("Left")
