extends KinematicBody2D

class_name Aircraft

################################################################################
# Enumerations

enum State { WAITING, FLYING, LANDED, EXPLODED, LEFT }


################################################################################
# Constants

# Usual gravity excerted by Earth.
const GRAVITY_STANDARD := 9.81
# Horizontal air speed.
const SPEED := 15.0
# Scale factor by which the other values are scaled for the game to be fun...
const SCALE := 12.0
# The maximum velocity where we consider the plane to be standing.
const STAND_STILL_VELOCITY := 3.0
# The maximum safe landing velocity for the softest of touch-downs.
const SAFE_LANDING_VELOCITY := 300.0
# Basically controls the rate of slowing down. Lower value means greater stopping distance
const SLOW_DOWN_ALPHA := 0.025


################################################################################
# Signals

# Emitted whenever the plane stops flying. The cause for the stop is encoded in
# the state variable, which has one of the values of the State enumeration.
signal stopped_flying(reason)


################################################################################
# Scene Objects

onready var _plane_body = $PlaneBody
onready var _rear_wheel_ray = $RearWheelRay
onready var _front_wheel_ray = $FrontWheelRay


################################################################################
# State

# The input controller used to steer the plane.
var input_controller: InputController setget set_input_controller

# State of the plane.
var _state = State.WAITING
# The plane's current velocity.
var _velocity := Vector2()
# Whether the plane is currently inside a landing area. Required for life-and-
# death types of decisions.
var _in_landing_area := false
# Whether the plane has touched down.
var _touch_down := false


################################################################################
# Effects

var _explosion = preload("res://scenes/Effects/Explosion.tscn")


################################################################################
# Scene Lifecycle

func _ready() -> void:
    # Initialize velocity
    _velocity.x = SPEED * SCALE
    _velocity.y = 0

    # If an input controller is part of the scene, find and install it
    for child in self.get_children():
        if child is InputController:
            input_controller = child

    _connect_to_landing_areas()

    # Don't process physics until the plane is started
    set_physics_process(false)


func _physics_process(delta: float) -> void:
    if _state != State.FLYING:
        return

    var _gravity = _compute_gravity(delta)

    # We'll only repell and rotate the plane if we're still in the air. Once we
    # have landed, we do things a little differently to keep the aircraft from
    # taking off again
    if not _touch_down:
        rotation = _velocity.angle()

    # Have gravity modify our vertical speed
    var new_velocity := _velocity
    new_velocity.y += _gravity * delta

    # ! It is important for smooth physics to update our velocity
    new_velocity = move_and_slide(new_velocity, Vector2.UP, false, 4, PI/2)

    var slide_count = get_slide_count()
    if slide_count > 0:
        if not _touch_down:
            # We're touching down for the first time. Ensure that we don't die
            if not _is_proper_touch_down():
                _die()
                return

        # Touch-down! Yankees Three!
        _touch_down = true
        # Slow the plane a bit
        new_velocity.x = lerp(new_velocity.x, 0.0, SLOW_DOWN_ALPHA)

    # Cange pitch of the plane if only one of its wheels has touched down
    _touch_down_both_wheels(_front_wheel_ray, _rear_wheel_ray)
    _touch_down_both_wheels(_rear_wheel_ray, _front_wheel_ray)

    # If we have touched down, we'd better be in a landing zone
    if _touch_down and _in_landing_area and new_velocity.x <= STAND_STILL_VELOCITY:
        new_velocity.x = 0
        _live()

    _velocity = new_velocity


# Updates the currently active gravity depending on player inputs.
func _compute_gravity(delta: float) -> float:
    if _touch_down:
        return GRAVITY_STANDARD * SCALE
    else:
        return input_controller.compute_gravity(delta) * SCALE


# Called when the plane touches down for the first time to check whether the touch down
# is in the designated landing area and soft enough for the passengers to not die.
func _is_proper_touch_down() -> bool:
    if not _in_landing_area:
        return false

    assert(get_slide_count() > 0)
    var collision: KinematicCollision2D = get_slide_collision(0)

    # Check if we touched down wheels-first
    if collision.local_shape == _plane_body:
        return false

    # Find how much of the maximum landing velocity is acceptable for safe touch-down.
    # This depends on the touch down angle.
    var factor := abs(sin(_velocity.angle_to(collision.normal)))

    return _velocity.length() <= SAFE_LANDING_VELOCITY * factor


# If one wheel already touches the ground, this function will apply the rotation necessary
# to have the other wheel touch the ground as well.
func _touch_down_both_wheels(touch_wheel: RayCast2D, flying_wheel: RayCast2D) -> void:
    if touch_wheel.is_colliding() and not flying_wheel.is_colliding():
        var normal: Vector2 = touch_wheel.get_collision_normal()
        var angle: float = normal.angle_to(Vector2.UP)
        rotation = lerp(rotation, -angle, 0.1)


################################################################################
# Plane Lifecycle

func start() -> void:
    _state = State.FLYING
    set_physics_process(true)


func _live() -> void:
    _state = State.LANDED
    emit_signal("stopped_flying", _state)


func _die() -> void:
    _state = State.EXPLODED

    _play_explosion_at_impact_location()
    queue_free()

    emit_signal("stopped_flying", _state)


################################################################################
# Landing Areas

func _connect_to_landing_areas() -> void:
    for o in get_tree().get_nodes_in_group(Constants.GROUP_LANDING_AREAS):
        if not o is Area2D:
            print("landing_areas contains non-Area2D node!")
            continue

        var landing_area: Area2D = o as Area2D
        landing_area.connect("body_entered", self, "_landing_area_triggered", [true])
        landing_area.connect("body_exited", self, "_landing_area_triggered", [false])


func _landing_area_triggered(body: PhysicsBody2D, entered: bool) -> void:
    if body == self:
        _in_landing_area = entered


################################################################################
# Accessors

# Sets the input controller and adds it to the plane as a child.
func set_input_controller(controller: InputController) -> void:
    input_controller = controller
    self.add_child(input_controller)


################################################################################
# Effects

func _play_explosion_at_impact_location():
    # Spawn the new instance in parent (to keep from getting freed)
    var instance = _explosion.instance()
    get_parent().add_child(instance)

    # Explosion only happens on collision, so we can use the current
    # collision to determine the impact angle and place and rotate the
    # explosion properly.
    var collision: KinematicCollision2D = get_slide_collision(0)

    instance.set_global_position(
        collision.position + Vector2(5,5)
    )
    instance.rotation = -collision.normal.angle_to(Vector2.UP)
