extends State


####################################################################################
# Scene Objects

onready var _menu_animation := $MenuAnimation
onready var _menu := $Menu
onready var _aircraft_animation := $Menu/Graphics/AircraftAnimation
onready var _play_button := $Menu/Controls/NewGameButton


####################################################################################
# Scene Lifecycle

func _ready() -> void:
    set_yield_on_pause(true)
    _menu.modulate = Color.transparent


####################################################################################
# State Lifecycle

func state_activated() -> void:
    .state_activated()

    _aircraft_animation.play("Wobble")


func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    print("Starting main menu")

    _menu_animation.play_backwards("FadeMenu")
    _play_button.grab_focus()


func state_paused(next_state: State) -> void:
    .state_paused(next_state)

    print("Pausing main menu")

    _menu_animation.play("FadeMenu")
    yield(_menu_animation, "animation_finished")


func state_deactivated() -> void:
    .state_deactivated()

    _aircraft_animation.stop()


####################################################################################
# Signal Handlers

func _on_NewGameButton_pressed() -> void:
    var params = { Constants.MENU_PARAM_LEVEL: 1 }
    transition_replace_all(Constants.MENU_STATE_LOAD_LEVEL)


func _on_QuitButton_pressed() -> void:
    get_tree().quit()
