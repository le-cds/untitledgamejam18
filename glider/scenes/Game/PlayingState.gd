extends State

# The playing state tells the plane to start flying,
class_name PlayingState


####################################################################################
# Scene Objects

onready var _animation: AnimationPlayer = $AnimationPlayer


####################################################################################
# State

var aircraft: Aircraft


####################################################################################
# State Lifecycle

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    # Start up the plane
    aircraft.start()

    # Fade in the HUD
    _animation.play("FadeHUD")
