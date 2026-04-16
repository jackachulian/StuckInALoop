// Original : Shader By Zacksly - https://zacksly.itch.io/
shader_type canvas_item;
//uniform bool UseColor; //removed because unnecessary in this case
uniform bool TransparentDot;
uniform float AspectRatio = 1.5;
uniform float Dots = 10.0;
uniform float _min;
uniform float _max = 1.0;
//uniform bool UseReshade; //removed because unnecessary in this case

uniform float outer_radius : hint_range(-5.0, 5.0) = 0.5;
uniform float dots_width : hint_range(-5.0, 5.0) = 0.1;
uniform vec2 center = vec2(0.5, 0.5);
uniform vec4 dots_color: source_color = vec4(1.0, 0.2, 0.2, 1.0);

uniform float height = 0.0;

void fragment() {
	vec3 uv_grid = fract(vec3(UV, 0.0) * vec3(AspectRatio * Dots, Dots, 0.0)); // replaced SCREEN_UV with UV

	float grid = distance(uv_grid, vec3(0.5, 0.5, 0.5));

	vec2 uv = UV;
    float dist = distance(uv, center);

    float mask = smoothstep(outer_radius+dots_width, outer_radius, 1.0-dist);

	bool dot_grid = grid < dot(vec3(mask), vec3(0.333333, 0.333333, 0.333333));

	//vec3 grid_result = BlackDot ? vec3(black_dot_grid ? 1.0 : 0.0) : vec3(white_dot_grid ? 1.0 : 0.0);	//vec4(texture_uv.r,texture_uv.g,texture_uv.b,1.0)
	vec4 grid_result = dot_grid ? dots_color : vec4(0.0);

	COLOR = grid_result;
}