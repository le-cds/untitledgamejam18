extends Node

################################################################################
# Constants

const TIME_FORMAT := "%02d:%02d:%02d"


################################################################################
# Scene Objects

onready var _time_label: Label = $TimeLabel


################################################################################
# State

# Whether the timer is currently running or not.
var _timer_running := false setget set_timer_running
# Number of milliseconds elapsed since starting the timer.
var _time_millis := 0


################################################################################
# Scene Lifecycle

func _ready() -> void:
    # We don't need processing as long as the timer is not running
    set_process(false)
    set_physics_process(false)


func _physics_process(delta: float) -> void:
    _time_millis += int(delta * 1000)
    _time_label.text = get_timer_string()


################################################################################
# Accessors

func set_timer_running(running: bool) -> void:
    if running != _timer_running:
        if running:
            _time_millis = 0

        running = _timer_running
        set_physics_process(_timer_running)


# Returns the timer's current value, in milliseconds.
func get_timer() -> int:
    return _time_millis


# Returns a displayable string representing the timer's current value.
func get_timer_string() -> String:
    var minutes := _time_millis / 60000
    var seconds := _time_millis / 1000
    var millis := (_time_millis % 1000) / 10
    return TIME_FORMAT % [minutes, seconds, millis]
