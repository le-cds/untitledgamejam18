extends State

# This is the state a level starts out with. Once started, this state waits for the player
# to issue the game start action and then switches to the playing state.
class_name WaitingState


func _physics_process(delta: float) -> void:
    if is_running():
        if Input.is_action_just_pressed("game_start"):
            transition_replace_single(Constants.GAME_STATE_PLAYING)
        elif Input.is_action_just_pressed("game_pause"):
            transition_push(Constants.GAME_STATE_PAUSED)
