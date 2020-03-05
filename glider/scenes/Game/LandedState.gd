extends State

# This state gets activated when the player lands successfully.
class_name LandedState

####################################################################################
# Signals

# Emitted when the player clicks the Main Menu button.
signal main_menu()
# Emitted when the player clicks the Try Again button.
signal try_again()
# Emitted when the player clicks the Next Level button.
signal next_level()


####################################################################################
# Constants

const PARAMS_TIME := "time"


####################################################################################
# Scene Objects

onready var _container := $Canvas/VBoxContainer
onready var _time_label: Label = $Canvas/VBoxContainer/TimeLabel
onready var _focus_button: Button = $Canvas/VBoxContainer/HBoxContainer/TryAgainButton

func _ready():
    # Since we can not control the visibility of canvas nodes, we need to hide the
    # top-most UI container, so it is only displayed when requested.
    # ... kind of annoying...
    _container.hide()

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


func _on_MenuButton_pressed() -> void:
    emit_signal("main_menu")

# Clone the visibility of the root node to the top-most UI container
func _on_visibility_changed():
    _container.visible = visible
