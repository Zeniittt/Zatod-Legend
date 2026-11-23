#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

float _DH = 360.0;
float _DS = 0.0;
float _DL= 0.0;

void main()
{
    vec4 color1 = texture2D(u_texture, v_texCoord) * v_fragmentColor;

    float r = color1.r;
    float g = color1.g;
    float b = color1.b;
    float a = color1.a;

    float h;
    float s;
    float l;

    // get H
    float maxv = max(max(r,g),b);
	float minv = min(min(r,g),b);
	float dif = maxv - minv;
	if (maxv == minv) {
		h = 0.0;
	} else if (maxv == r && g >= b) {
        h = 60.0 * (g - b) / dif + 0.0;
    } else if (maxv == r && g < b) {
		h = 60.0 * (g - b) / dif + 360.0;
	} else if (maxv == g) {
		h = 60.0 * (b - r) / dif + 120.0;
	}  else if (maxv == b) {
		h = 60.0 * (r - g) / dif + 240.0;
	}

    l = 0.5 * (maxv + minv);
    if (l == 0.0 || maxv == minv) {
        s = 0.0;
    } else if (0.0 <= l && l <= 0.5) {
        s = dif / (2.0 * l);
    } else if (l > 0.5) {
        s = dif / (2.0 - 2.0 * l);
    }

    h = h + _DH;
    s = min(1.0, max(0.0, s + _DS));
    l = l + _DL;

    float q;
    if (l < 0.5) {
        q = l * (1.0 + s);
    } else if (l >= 0.5) {
        q = l + s - l * s;
    }

    float p = 2.0 * l - q;
    float hk = h / 360.0;
    float t[3];
    t[0] = hk + 1.0 / 3.0;
    t[1] = hk;
    t[2] = hk - 1.0 / 3.0;
    for (int i = 0; i < 3; i++) {
        if (t[i] < 0.0) {
            t[i] += 1.0;
        } else if (t[i] > 1.0) {
            t[i] -= 1.0;
        }
    }
    float c[3];
    for (int i = 0; i < 3; i++) {
        if (t[i] < 1.0 / 6.0) {
            c[i] = p + ((q - p) * 6.0 * t[i]);
        } else if (1.0 / 6.0 <= t[i] && t[i] < 0.5) {
            c[i] = q;
        } else if (0.5 <= t[i] && t[i] < 2.0 / 3.0) {
            c[i] = p + ((q - p) * 6.0 * (2.0 / 3.0 - t[i]));
        } else {
            c[i] = p;
        }
    }

    vec4 finalColor = vec4(c[0], c[1], c[2], a);
    finalColor += vec4(_DL, _DL, _DL, 0.0);

    gl_FragColor = finalColor;
}
