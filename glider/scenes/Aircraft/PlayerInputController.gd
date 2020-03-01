extends InputController

# This input controller lets the player steer the plane through key presses.
class_name PlayerInputController


################################################################################
# Constants

# Absolute of the maximum gravity value attainable.
const GRAVITY_MAX := 30.0
# The time in seconds it takes for gravity to go from 0 to full when full
# controller input is active.
const GRAVITY_MAX_TIME := 0.3


################################################################################
# State

# Currently active gravity acting on the plane.
var _gravity := 0.0


################################################################################
# Functions

func compute_gravity(delta: float) -> float:
    var gravity_input := Input.get_action_strength("game_gravity_down")
    gravity_input -= Input.get_action_strength("game_gravity_up")

    _gravity += gravity_input / GRAVITY_MAX_TIME * delta * GRAVITY_MAX
    _gravity = clamp(_gravity, -GRAVITY_MAX, GRAVITY_MAX)

    return _gravity
