extends KinematicBody2D

# m^2
export var wing_area: float = 20.0
# kg
export var plane_mass: float = 100.0

export var lift_coefficient: float  = 1.0
export var drag_coefficient: float  = 1.0
export var air_density: float  = 3.9
export var initial_velocity: Vector2 = Vector2(1.0, 0.0)
export var gravity: float = 9.81

var _velocity: Vector2 = Vector2.ZERO
var _world_velocity: Vector2 = Vector2.ZERO
var _velocity_amplitude: float = 0.0
var _plane_rotation: float = -PI/4
var _input_rotation: float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready():
    rotation = deg2rad(_plane_rotation)
    _velocity_amplitude = initial_velocity.length()

func _physics_process(delta):
    if Input.is_action_pressed("ui_up"):
        gravity+=1.0
    elif Input.is_action_pressed("ui_down"):
        gravity-=1.0

    var v_dot = -gravity * sin(_plane_rotation) \
                - (1.0/(2.0*plane_mass) * air_density * wing_area * drag_coefficient) \
                * _velocity_amplitude * _velocity_amplitude

    var rotational_velocity = -gravity / _velocity_amplitude * cos(_plane_rotation) \
                    + (1.0/(2.0*plane_mass) * air_density * wing_area * lift_coefficient) \
                    * _velocity_amplitude

    _velocity_amplitude += v_dot * delta
    _plane_rotation += rotational_velocity * delta

    _velocity = Vector2(
        _velocity_amplitude * cos(_plane_rotation),
        -_velocity_amplitude * sin(_plane_rotation)
    )
    # Our sprite rotation is inverse to our physical rotation
    rotation = -_plane_rotation

    move_and_collide(_velocity)
