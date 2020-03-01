shader_type canvas_item;
uniform float scroll_speed;
uniform vec2 initial_uv_offset;

void fragment() {
    vec2 uv = UV + initial_uv_offset;
    
    // Ensure that we flip every second texture verticall
    if (int(uv.x) % 2 == 0) {
        uv *= vec2(-1, 1);
    }
    
    vec4 color = texture(TEXTURE, uv);
    COLOR = color;
}