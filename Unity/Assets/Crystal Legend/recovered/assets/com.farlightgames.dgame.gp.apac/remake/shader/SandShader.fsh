#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()
{
    vec4 color1 = texture2D(u_texture, v_texCoord) * v_fragmentColor;
	float brightness = (color1.r + color1.g + color1.b) * (1. / 1.8);
	float grayR = (1. ) * brightness;
	float grayG = (0.75) * brightness;
	float grayB = (0.4) * brightness;
    gl_FragColor = vec4(grayR, grayG, grayB, color1.a);
}
