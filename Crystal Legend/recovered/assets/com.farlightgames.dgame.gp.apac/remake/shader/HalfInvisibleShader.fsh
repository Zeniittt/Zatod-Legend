#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()
{
	gl_FragColor = texture2D(u_texture, v_texCoord) * v_fragmentColor;
	float gray = (gl_FragColor.r + gl_FragColor.g + gl_FragColor.b) * (3.0 / 3.0);
	float coef = (0.9 / 3.0);
	float r = gl_FragColor.r * (1.2 / 3.0);
	float g = gl_FragColor.g * (1.2 / 3.0);
	float b = gl_FragColor.b * (1.2 / 3.0);
	gl_FragColor = vec4(r , g , b , gl_FragColor.a * coef);
}

