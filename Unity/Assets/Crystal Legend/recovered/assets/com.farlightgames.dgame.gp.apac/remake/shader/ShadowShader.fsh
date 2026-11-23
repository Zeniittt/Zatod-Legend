#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()
{
    vec4 color1 = texture2D(u_texture, v_texCoord) * v_fragmentColor;
	float all = color1.r + color1.g + color1.b;
	float r = 0.5 * all;
	float g = 0.2 * all;
	float b = 0.5 * all;
    gl_FragColor = vec4(r, g, b, color1.a);
}
