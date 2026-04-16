shader_type spatial;

render_mode unshaded, cull_disabled;

uniform vec4 flash_color: source_color = vec4(1.0, 0.2, 0.2, 1.0);
uniform float flash_strength = 0.0;
uniform sampler2D tex: source_color;

void fragment() {
	vec4 color = texture(tex, UV);
	ALPHA = color.a;
	ALBEDO = mix(color.rgb, flash_color.rgb, flash_strength);
}