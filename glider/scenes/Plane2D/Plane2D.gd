extends KinematicBody2D

################################################################################
# Constants

# Horizontal air speed.
const SPEED := 15.0
# Usual gravity excerted by Earth.
const GRAVITY_STANDARD := 9.81
# Repelling, anti-gravity excerted when the player presses a button.
const GRAVITY_UP := -15.0
# Scale factor by which the other values are scaled for the game to be fun...
const SCALE := 12.0


################################################################################
# Scene Objects

onready var _rear_wheel_ray = $RearWheelRay
onready var _front_wheel_ray = $FrontWheelRay


################################################################################
# State

# The plane's current velocity.
var _velocity := Vector2()
# Whether the plane has touched down.
var _on_floor := false


################################################################################
# Scene Lifecycle

func _ready() -> void:
    _velocity.x = SPEED * SCALE
    _velocity.y = 0


func _physics_process(delta: float) -> void:
    var _gravity := GRAVITY_STANDARD * SCALE
    
    # We'll only repell and rotate the plane if we're still in the air. Once we
    # have landed, we do things a little differently to keep the aircraft from
    # taking off again
    if not _on_floor:
        if Input.is_action_pressed("game_gravity_switch"):
            _gravity = GRAVITY_UP * SCALE

        rotation = _velocity.angle()
    
    # Have gravity modify our vertical speed
    _velocity.y += _gravity * delta

    # Don't know, which argument permutation is better
    move_and_slide(_velocity, Vector2.UP, false, 4, PI/2)
    # move_and_slide(_velocity)

    var slide_count = get_slide_count()
    if slide_count > 0:
        # Touch-down! Yankees Three!
        _on_floor = true
        
        # Slow the plane a bit
        _velocity.x = lerp(_velocity.x, 0.001, 0.01)

    # Cange pitch of the plane if only one of its wheels has touched down
    _touch_down(_front_wheel_ray, _rear_wheel_ray)
    _touch_down(_rear_wheel_ray, _front_wheel_ray)


func _touch_down(touch_wheel: RayCast2D, flying_wheel: RayCast2D) -> void:
    if touch_wheel.is_colliding() and not flying_wheel.is_colliding():
        var normal: Vector2 = touch_wheel.get_collision_normal()
        var angle: float = normal.angle_to(Vector2.UP)
        rotation = lerp(rotation, -angle, 0.1)
