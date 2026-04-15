shader_type canvas_item;

uniform float outer_radius : hint_range(0.0, 1.5) = 1.0;
uniform vec2 center = vec2(0.5, 0.5);

void fragment() {
    vec2 uv = UV;
    float dist = distance(uv, center);

    float mask = smoothstep(outer_radius, outer_radius - 0.0002, 1.0-dist);

    COLOR = vec4(0.0, 0.0, 0.0, mask);
}