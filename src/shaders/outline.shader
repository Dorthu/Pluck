shader_type canvas_item;
render_mode unshaded;

// should we render?
uniform bool on;

// fragment runs on each pixel before lighting is applied
void fragment() {
	COLOR = texture(TEXTURE, UV);
	
	if(on) {
		vec2 pixel_size = TEXTURE_PIXEL_SIZE*1.5;
		
		// if we are transparent
		if(COLOR.a < 0.2) {
			vec4 up = texture(TEXTURE, UV+vec2(0, -1)*pixel_size);
			vec4 left = texture(TEXTURE, UV+vec2(-1, 0)*pixel_size);
			vec4 down = texture(TEXTURE, UV+vec2(0, 1)*pixel_size);
			vec4 right = texture(TEXTURE, UV+vec2(1, 0)*pixel_size);
			
			// if an adjacent space is not transparent
			if(up.a >= .2 || left.a >= .2 || down.a >= .2 || right.a >= .2) {
				COLOR = vec4(.8, .85, .2, 1);
			}
		}
	}
}