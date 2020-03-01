shader_type canvas_item;
uniform float scroll_speed;
uniform vec2 initial_uv_offset;

void fragment() {
    vec2 uv = UV + initial_uv_offset;
    uv.x += TIME * scroll_speed;
    vec4 color = texture(TEXTURE, uv);
    COLOR = color;
}