#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform sampler2D CC_Texture0;

uniform vec4 HSV;

void main()
{
	vec4 textureColor = texture2D(CC_Texture0, v_texCoord);
	float r = textureColor.r;
	float g = textureColor.g;
	float b = textureColor.b;
	float a = textureColor.a;

	float h;
	float s;
	float v;
	//convert RGB to HSV

	float max = max(max(r,g), b);
	float min = min(min(r,g), b);
	float dif = max - min;

	//H
	if (max==min) {
		h = 0.0;
	} 
	else if (max == r) {
		if (g >= b) {
			h = 60.0*(g-b)/dif;
		} else {
			h = 60.0*(g-b)/dif + 360.0;
		}
	} 
	else if (max == g) {
		h = 60.0*(b-r)/dif + 120.0;
	} 
	else if(max == b) {
		h = 60.0*(r-g)/dif + 240.0;
	}

	//S
	if (max == 0.0) {
		s = 0.0;
	} else {
		s = dif/max;
	}

	//V
	v = max;

	h = h + HSV.x;
	s = s + HSV.y;
	v = v + HSV.z;

	//convert HSV to RGB
	float delat = floor(h/60.0);
	float hk = delat - floor(delat/6.0) * 6.0;
	float f = h/60.0 - hk;
	float p = v * (1.0 - s);
	float q = v * (1.0 - f * s);
	float t = v * (1.0 - (1.0 - f) * s);

	if (hk == 0.0) {
		r = v;
		g = t;
		b = p;
	} else if (hk == 1.0) {
		r = q;
		g = v;
		b = p;
	} else if (hk == 2.0) {
		r = p;
		g = v;
		b = t;
	} else if (hk == 3.0) {
		r = p;
		g = q;
		b = v;
	} else if (hk == 4.0) {
		r = t;
		g = p;
		b = v;
	} else {
		r = v;
		g = p;
		b = q;
	}
	

	gl_FragColor = vec4(r , g , b , a);
}
