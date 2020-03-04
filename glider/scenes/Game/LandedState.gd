extends State

# This state gets activated when the player lands successfully.
class_name LandedState

####################################################################################
# Signals

# Emitted when the player clicks the Try Again button.
signal try_again()
# Emitted when the player clicks the Next Level button.
signal next_level()


####################################################################################
# Constants

const PARAMS_TIME := "time"


####################################################################################
# Scene Objects

onready var _time_label: Label = $VBoxContainer/TimeLabel
onready var _focus_button: Button = $VBoxContainer/HBoxContainer/TryAgainButton


####################################################################################
# State

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    if params.has(PARAMS_TIME):
        _time_label.text = Util.millis_to_string(params[PARAMS_TIME])

    _focus_button.grab_focus()


####################################################################################
# Event Handling

func _on_TryAgainButton_pressed() -> void:
    emit_signal("try_again")


func _on_NextLevelButton_pressed() -> void:
    emit_signal("next_level")
