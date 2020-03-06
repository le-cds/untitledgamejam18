extends CanvasLayer

class_name HUD

################################################################################
# Scene Objects

onready var _time_label: Label = $TimeLabel
onready var _gforce_label: Label = $GForceLabel


################################################################################
# State

# Modulation to be passed on to our GUI elements for smooth fading.
export(Color) var modulate := Color(1, 1, 1, 1) setget set_modulate

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
    
    # Apply initial modulate values now that our scene object variables are
    # initialized
    set_modulate(modulate)


func _physics_process(delta: float) -> void:
    _time_millis += int(delta * 1000)
    _time_label.text = Util.millis_to_string(_time_millis)


################################################################################
# Accessors

func set_modulate(color: Color) -> void:
    modulate = color
    
    if _time_label:
        _time_label.modulate = modulate
        _gforce_label.modulate = modulate


func set_timer_running(running: bool) -> void:
    if running != _timer_running:
        if running:
            _time_millis = 0

        _timer_running = running
        set_physics_process(_timer_running)


# Returns the timer's current value, in milliseconds.
func get_timer() -> int:
    return _time_millis


func set_gravity(value: float) -> void:
    _gforce_label.text = str(stepify(value/9.81, 0.1)) + "G"
