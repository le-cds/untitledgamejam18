extends Node

# An input controller allows the plane to be steered.
class_name InputController


# Whether the plane should start flying.
func start_plane() -> bool:
    return false


# The new gravity.
func compute_gravity(delta: float) -> float:
    return 0.0
