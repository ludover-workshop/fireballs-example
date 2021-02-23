shader_type canvas_item;

uniform vec4 blink_color: hint_color = vec4(1);
uniform float blinking_frequency = 10;

uniform float blink_intensity: hint_range(0, 1) = 0;

void fragment() {
	vec4 original_color = texture(TEXTURE, UV);
	float blink_value = ((sin(TIME * blinking_frequency * 2.0) * 0.5) + 0.5) * blink_intensity;
	
	COLOR = original_color * (1.0 - blink_value) + blink_color *  blink_value;
	COLOR.a = original_color.a;
}