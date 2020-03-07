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
onready var _animation := $Canvas/AnimationPlayer
onready var _time_label: Label = $Canvas/VBoxContainer/TimeLabel
onready var _focus_button: Button = $Canvas/VBoxContainer/HBoxContainer/TryAgainButton
onready var _next_level_button: Button = $Canvas/VBoxContainer/HBoxContainer/NextLevelButton


####################################################################################
# Scene Lifecycle

func _ready():
    set_yield_on_pause(true)
    _container.modulate = Color.transparent


####################################################################################
# State Lifecycle

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    if params.has(PARAMS_TIME):
        _time_label.text = Util.millis_to_string(params[PARAMS_TIME])

    # Setup UI
    _animation.play_backwards("FadeMenu")
    _focus_button.grab_focus()


func state_paused(next_state: State) -> void:
    .state_paused(next_state)

    _animation.play("FadeMenu")
    yield(_animation, "animation_finished")


####################################################################################
# Configuration

# Shows or hides the next level button.
func show_next_level_button(show: bool) -> void:
    _next_level_button.visible = show


####################################################################################
# Event Handling

func _on_TryAgainButton_pressed() -> void:
    if is_running():
        emit_signal("try_again")


func _on_NextLevelButton_pressed() -> void:
    if is_running():
        emit_signal("next_level")


func _on_MenuButton_pressed() -> void:
    if is_running():
        emit_signal("main_menu")
