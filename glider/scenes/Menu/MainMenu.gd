extends State


####################################################################################
# Scene Objects

onready var _animation: AnimationPlayer = $Graphics/AnimationPlayer
onready var _play_button: Button = $Controls/NewGameButton


####################################################################################
# State Lifecycle

func state_activated() -> void:
    .state_activated()

    _animation.play("Wobble")


func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    _play_button.grab_focus()


func state_deactivated() -> void:
    .state_deactivated()

    _animation.stop()



####################################################################################
# Signal Handlers

func _on_NewGameButton_pressed() -> void:
    var params = { Constants.MENU_PARAM_LEVEL: 1 }
    transition_replace_all(Constants.MENU_STATE_LOAD_LEVEL)


func _on_QuitButton_pressed() -> void:
    get_tree().quit()
