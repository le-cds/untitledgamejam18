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

# We need this flag to prevent access to the invalidated airplane
# (e.g. being freed after crashing)
var _is_aircraft_valid = false


####################################################################################
# Scene Lifecycle

func _process(delta: float) -> void:
    if is_running() and Input.is_action_just_pressed("game_pause"):
        transition_push(Constants.GAME_STATE_PAUSED)


func _physics_process(delta):
    if _is_aircraft_valid:
        _hud.set_gravity(aircraft.get_gravity())


####################################################################################
# State Lifecycle

func state_activated() -> void:
    .state_activated()

    # Start up everything
    aircraft.start()
    _hud.set_timer_running(true)


func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    # Fade in the HUD
    _animation.play("FadeHUD")


func state_paused(next_state: State) -> void:
    .state_paused(next_state)

    # Fade out the HUD
    _animation.play_backwards("FadeHUD")


####################################################################################
# Accessors

func set_aircraft(craft: Aircraft) -> void:
    aircraft = craft
    _is_aircraft_valid = true
    aircraft.connect("stopped_flying", self, "_on_aircraft_stopped_flying")

####################################################################################
# Signal Handlers

func _on_aircraft_stopped_flying(reason) -> void:
    # Stop the timer before we decide what we should actually do
    _hud.set_timer_running(false)

    # Setup the correct end screen
    var params = {}
    var target: String

    if reason == Aircraft.State.LANDED:
        params[LandedState.PARAMS_TIME] = _hud.get_timer()
        target = Constants.GAME_STATE_LANDED
    else:
        params[FailState.PARAMS_REASON] = reason
        target = Constants.GAME_STATE_FAILED
        # In non-landed case, we expect the plane may be freed
        _is_aircraft_valid = false

    transition_push(target, params)
