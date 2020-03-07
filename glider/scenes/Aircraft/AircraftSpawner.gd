extends Sprite

# Can be placed in scenes to spawn aircraft. Won't be displayed during the game. Aircraft can be
# automatically setup with a camera. Aircraft will be spawned as children of this node's parent,
# directly below this node.
class_name AircraftSpawner


####################################################################################
# Scene Lifecycle

func _ready() -> void:
    # Make this thing invisible
    visible = false


####################################################################################
# Spawning

var _aircraft_scene: PackedScene = preload("res://scenes/Aircraft/Aircraft.tscn")

# Spawns a new aircraft node, add's it to the parent below this node, and returns it. Optionally
# adds a properly configured Camera2D (default). If so, the camera can immediately be made the
# current camera (default).
func spawn(add_camera: bool = true, make_current: bool = true) -> Aircraft:
    # Spawn and add aircraft
    var aircraft: Aircraft = _aircraft_scene.instance()
    aircraft.position = self.position
    get_parent().add_child_below_node(self, aircraft)

    # Add camera, if requested
    if add_camera:
        var camera := Camera2D.new()

        camera.current = make_current
        # TODO Setup proper limits
        camera.limit_left = 0
        camera.limit_top = 0
        camera.limit_right = 960
        camera.limit_bottom = 540
        camera.limit_smoothed = true
        camera.smoothing_enabled = true

        aircraft.add_child(camera)

    return aircraft
