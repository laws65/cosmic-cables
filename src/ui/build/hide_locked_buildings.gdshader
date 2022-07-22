shader_type canvas_item;


const float darken_amount = 0.4;


void fragment() {
	COLOR = texture(TEXTURE, UV);
	COLOR.rgb *= darken_amount;
}