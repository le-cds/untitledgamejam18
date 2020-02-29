extends KinematicBody2D

const SPEED := 15.0
const GRAVITY_STANDARD := 9.81
const GRAVITY_UP := -15.0
const SCALE := 12.0

var _gravity := GRAVITY_STANDARD
var _velocity := Vector2()


func _ready() -> void:
	_velocity.x = SPEED * SCALE
	_velocity.y = 0


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("game_gravity_switch"):
		_gravity = GRAVITY_UP * SCALE
	else:
		_gravity = GRAVITY_STANDARD * SCALE
	
	_velocity.y += _gravity * delta
	
	rotation = _velocity.angle()
	
	move_and_collide(_velocity * delta)
