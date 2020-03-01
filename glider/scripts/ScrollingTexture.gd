extends TextureRect

# Nodes that have this script attached also need a material
# with `ScrollingTexture.shader` or just simply the `ScrollingTexture.material`.

# Scroll speed in UV/frame
# TODO: Make this a more convenient unit
export var scroll_speed: float = 0.1

# Initial offset of the texture in UV coordinates.
# Can be used to make multiple backgrounds of the same
# texture not look completely identical.
export var initial_uv_offset: Vector2 = Vector2.ZERO

func _ready():
    self.stretch_mode = TextureRect.STRETCH_TILE
    self.material.set_shader_param("scroll_speed", scroll_speed)
    self.material.set_shader_param("initial_uv_offset", initial_uv_offset)