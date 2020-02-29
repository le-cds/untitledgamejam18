extends KinematicBody2D

const SPEED := 15.0
const GRAVITY_STANDARD := 9.81
const GRAVITY_UP := -15.0
const SCALE := 12.0

var _gravity := GRAVITY_STANDARD
var _velocity := Vector2()

var _stop_alpha := 0.0
var _on_floor := false
var stop_duration = 3.0


func _ready() -> void:
    _velocity.x = SPEED * SCALE
    _velocity.y = 0


func _physics_process(delta: float) -> void:

    if not _on_floor:
        if Input.is_action_pressed("game_gravity_switch"):
            _gravity = GRAVITY_UP * SCALE
        else:
            _gravity = GRAVITY_STANDARD * SCALE

        rotation = _velocity.angle()
    else:
        _gravity = GRAVITY_STANDARD * SCALE

    _velocity.y += _gravity * delta

    move_and_slide(_velocity)

    var slide_count = get_slide_count()
    print(slide_count)
    if slide_count > 0 and not _on_floor:
        _on_floor = true
        _stop_alpha = 0.0

    if slide_count > 0:
        _stop_alpha += delta * slide_count
        var collision: KinematicCollision2D = get_slide_collision(0)
        _velocity.x = lerp(_velocity.x, 0, _stop_alpha / stop_duration)
        # print(_velocity.x)
