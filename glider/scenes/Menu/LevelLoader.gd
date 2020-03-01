extends State

# This state is responsible for loading new or reloading old levels.
class_name LevelLoader


####################################################################################
# Scene Objects

onready var _animation: AnimationPlayer = $AnimationPlayer
onready var _audio: AudioStreamPlayer = $AudioStreamPlayer
onready var _timer: Timer = $Timer


####################################################################################
# State

# Number of the current level.
var _current_level := 0
# The current level's root node, if any.
var _current_level_node: Node
# Whether we're currently loading a level.
var _loading := false
# Whether the timer has already finished.
var _timer_finished := false
# Interactive loader used to load a level (if we're currently doing so)
var _level_loader: ResourceInteractiveLoader


####################################################################################
# State Lifecycle

func state_started(prev_state: State, params: Dictionary) -> void:
    .state_started(prev_state, params)

    # Restart timer, audio, and animation
    _timer_finished = false
    _timer.start()
    _audio.play(0)
    _animation.play("WobbleAircraft")

    # If there is a current level node, get rid of it
    if _current_level_node:
        self.get_parent().remove_state(_state_id_for_level(_current_level))
        _current_level_node.queue_free()

    # Check which level to load
    # TODO Check absolute instead of relative level loading as well.
    if params.has(Constants.MENU_PARAM_LEVEL):
        if params[Constants.MENU_PARAM_LEVEL] == Constants.MENU_PARAM_LEVEL_NEXT:
            _current_level += 1
    else:
        _current_level = 1

    # TODO We should properly handle invalid levels
    _current_level = clamp(_current_level, 1, Constants.LEVELS)

    # Start loading the next level
    var level_file := "res://scenes/Levels/%02d/Level%02d.tscn" % [_current_level, _current_level]
    _level_loader = ResourceLoader.load_interactive(level_file)
    _loading = true


func state_paused(next_state: State) -> void:
    .state_paused(next_state)

    _audio.stop()
    _animation.stop(true)


####################################################################################
# Level Load Management

func _process(delta: float) -> void:
    # Check if our level has finished loading
    if _loading:
        if _level_loader.poll() == ERR_FILE_EOF:
            _loading = false
            _should_start_level()


# Loads and starts the level if (i) the loader has finished loading it and (ii) the
# timer says we've had enough of the wobbling aircraft
func _should_start_level() -> void:
    if not _loading and _timer_finished:
        # Instantiate the level
        _current_level_node = _level_loader.get_resource().instance()
        _level_loader = null

        # Register with state machine and switch to level
        var level_state_id := _state_id_for_level(_current_level)
        _current_level_node.state_id = level_state_id
        self.get_parent().add_state(_current_level_node)
        transition_replace_single(level_state_id)


####################################################################################
# Event Management

func _on_Timer_timeout() -> void:
    _timer_finished = true
    _should_start_level()


####################################################################################
# Utilities

func _state_id_for_level(level: int) -> String:
    return "level%02d" % level
