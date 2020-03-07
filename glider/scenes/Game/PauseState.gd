extends State

# This state gets activated when the player pauses the game..
class_name PauseState


####################################################################################
# Signals

# Emitted when the player clicks the Main Menu button.
signal main_menu()


####################################################################################
# Scene Objects

onready var _animation: AnimationPlayer = $CanvasLayer/AnimationPlayer
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
    set_yield_on_pause(true)
    _container.modulate = Color.transparent


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

    # Setup UI
    _animation.play_backwards("FadeMenu")
    _focus_button.grab_focus()


func state_paused(next_state: State) -> void:
    .state_paused(next_state)

    # Recover from Pause mode
    get_tree().paused = false

    _animation.play("FadeMenu")
    yield(_animation, "animation_finished")


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
