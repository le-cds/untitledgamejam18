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
const SAFE_LANDING_VELOCITY := 500.0
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
# The current gravity (unscaled)
var _gravity := 0.0
# Whether the plane is currently inside a landing area. Required for life-and-
# death types of decisions.
var _in_landing_area := false
# Whether the plane has touched down.
var _on_ground := false


################################################################################
# Effects

var _explosion_effect = preload("res://scenes/Effects/Explosion.tscn")
var _landed_effect = preload("res://scenes/Effects/Landed.tscn")


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

    _connect_to_areas(Constants.GROUP_LEVEL_AREA)
    _connect_to_areas(Constants.GROUP_LANDING_AREAS)

    # Don't process physics until the plane is started
    set_physics_process(false)


func _physics_process(delta: float) -> void:
    if _state != State.FLYING:
        return

    var _gravity_scaled = _compute_scaled_gravity(delta)

    # We'll only repell and rotate the plane if we're still in the air. Once we
    # have landed, we do things a little differently to keep the aircraft from
    # taking off again
    if not _on_ground:
        rotation = _velocity.angle()

    # Have gravity modify our vertical speed
    var new_velocity := _velocity
    new_velocity.y += _gravity_scaled * delta

    # ! It is important for smooth physics to update our velocity
    new_velocity = move_and_slide(new_velocity, Vector2.UP, false, 4, PI/2)

    # Check if we're touching down
    if not _on_ground and get_slide_count() > 0:
        if _is_proper_touch_down():
            # Touch-down! Yankees Three!
            _on_ground = true
        else:
            _die()
            return

    # If we're on the ground, we need to slow down and possibly collide with houses
    if _on_ground:
        if _has_main_body_hit_stuff():
            _die()
            return
        else:
            new_velocity.x = lerp(new_velocity.x, 0.0, SLOW_DOWN_ALPHA)

    # Cange pitch of the plane if only one of its wheels has touched down
    _touch_down_both_wheels(_front_wheel_ray, _rear_wheel_ray)
    _touch_down_both_wheels(_rear_wheel_ray, _front_wheel_ray)

    # If we have touched down, we'd better be in a landing zone
    if _on_ground and _in_landing_area and new_velocity.x <= STAND_STILL_VELOCITY:
        new_velocity.x = 0
        _live()

    _velocity = new_velocity


# Updates the currently active gravity depending on player inputs.
func _compute_scaled_gravity(delta: float) -> float:
    if _on_ground:
        _gravity = GRAVITY_STANDARD
    else:
        _gravity = input_controller.compute_gravity(delta)

    return _gravity * SCALE


# Checks whether there is a collision involving something other than the aircraft's
# wheels. That will usually cause us to die a horrible, painful death.
func _has_main_body_hit_stuff() -> bool:
    for i in get_slide_count():
        var collision: KinematicCollision2D = get_slide_collision(i)

        if collision.local_shape == _plane_body:
            return true

    return false


# Called when the plane touches down for the first time to check whether the touch down
# is in the designated landing area and soft enough for the passengers to not die.
func _is_proper_touch_down() -> bool:
    assert(get_slide_count() > 0)

    if not _in_landing_area:
        return false

    if _has_main_body_hit_stuff():
        return false

    # Find how much of the maximum landing velocity is acceptable for safe touch-down.
    # This depends on the touch down angle.
    var collision: KinematicCollision2D = get_slide_collision(0)
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

# Starts the airplane.
func start() -> void:
    _state = State.FLYING
    set_physics_process(true)


# Called when the airplane came to a safe halt.
func _live() -> void:
    _state = State.LANDED

    _play_success_at_standstill_location()

    emit_signal("stopped_flying", _state)


# Called when the airplaine explodes.
func _die() -> void:
    _state = State.EXPLODED

    _play_explosion_at_impact_location()
    queue_free()

    emit_signal("stopped_flying", _state)


# Called when the airplane has left the level.
func _leave() -> void:
    _state = State.LEFT

    queue_free()

    emit_signal("stopped_flying", _state)


################################################################################
# Landing Areas

func _connect_to_areas(group: String) -> void:
    for o in get_tree().get_nodes_in_group(group):
        if not o is Area2D:
            print(group + " contains non-Area2D node!")
            continue

        var landing_area: Area2D = o as Area2D
        landing_area.connect("body_entered", self, "_area_triggered", [group, true])
        landing_area.connect("body_exited", self, "_area_triggered", [group, false])


func _area_triggered(body: PhysicsBody2D, group: String, entered: bool) -> void:
    if body == self:
        # What we do depends on which kind of an area we have
        if group == Constants.GROUP_LANDING_AREAS:
            _in_landing_area = entered
        elif group == Constants.GROUP_LEVEL_AREA and entered == false:
            _leave()


################################################################################
# Accessors

# Sets the input controller and adds it to the plane as a child.
func set_input_controller(controller: InputController) -> void:
    input_controller = controller
    self.add_child(input_controller)

func get_gravity() -> float:
    return _gravity


################################################################################
# Effects

func _play_explosion_at_impact_location():
    # Spawn the new instance in parent (to keep from getting freed)
    var instance = _explosion_effect.instance()
    get_parent().add_child(instance)

    # Explosion only happens on collision, so we can use the current
    # collision to determine the impact angle and place and rotate the
    # explosion properly.
    var collision: KinematicCollision2D = get_slide_collision(0)

    instance.set_global_position(
        collision.position + Vector2(5,5)
    )
    instance.rotation = -collision.normal.angle_to(Vector2.UP)


func _play_success_at_standstill_location():
    # Spawn the new instance in parent (to keep from getting freed)
    var instance = _landed_effect.instance()
    get_parent().add_child(instance)

    instance.set_global_position(
        self.global_position
    )
