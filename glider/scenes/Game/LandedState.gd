extends State

# This state gets activated when the player lands successfully.
class_name LandedState

####################################################################################
# Constants

const PARAMS_TIME := "time"


####################################################################################
# Scene Objects

onready var _time_label: Label = $VBoxContainer/TimeLabel


####################################################################################
# State

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    if params.has(PARAMS_TIME):
        _time_label.text = Util.millis_to_string(params[PARAMS_TIME])


func _on_TryAgainButton_pressed() -> void:
    # TODO Implement
    print("Try Again")


func _on_NextLevelButton_pressed() -> void:
    # TODO Implement
    print("Next Level")
