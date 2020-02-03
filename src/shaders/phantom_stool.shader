shader_type canvas_item;
render_mode unshaded;

// this is the texture we're rendering
uniform sampler2D Texture;

// fragment runs on each pixel before lighting is applied
void fragment() {
	// sample the texture at this pixel
	COLOR = texture(Texture, UV);
	// if this pixel isn't transparent already, make it flash
	if(COLOR.a > 0.0) {
		COLOR.a = max(.1, (cos(TIME*1.8)-UV.y) * .8);
	}
}