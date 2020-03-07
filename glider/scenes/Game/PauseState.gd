extends State

# This state gets activated when the player pauses the game..
class_name PauseState


####################################################################################
# Signals

# Emitted when the player clicks the Main Menu button.
signal main_menu()


####################################################################################
# Scene Objects

onready var _container: Container = $CanvasLayer/VBoxContainer
onready var _focus_button: Button = $CanvasLayer/VBoxContainer/HBoxContainer/ContinueButton


####################################################################################
# State

# Tracks whether the pause menu had a chance to be fully displayed. Without this
# flag, the menu will immediately close again since it things the pause menu trigger
# was pressed.
var _is_properly_paused := false


####################################################################################
# Scene Lifecycle

func _ready():
    # Since we can not control the visibility of canvas nodes, we need to hide the
    # top-most UI container, so it is only displayed when requested.
    # ... kind of annoying...
    _container.hide()


func _process(delta: float) -> void:
    if is_running():
        if _is_properly_paused and Input.is_action_just_pressed("game_pause"):
            _continue()
        else:
            _is_properly_paused = true


####################################################################################
# State Lifecycle

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    # Put Godot into Pause mode
    get_tree().paused = true
    _is_properly_paused = false

    _focus_button.grab_focus()


func state_paused(next_state: State) -> void:
    .state_paused(next_state)

    # Recover from Pause mode
    get_tree().paused = false


####################################################################################
# Utilities

# Return to the previous state
func _continue() -> void:
    transition_pop()


####################################################################################
# Event Handling

func _on_MenuButton_pressed() -> void:
    emit_signal("main_menu")


func _on_ContinueButton_pressed() -> void:
    _continue()


# Clone the visibility of the root node to the top-most UI container
func _on_visibility_changed():
    _container.visible = visible
