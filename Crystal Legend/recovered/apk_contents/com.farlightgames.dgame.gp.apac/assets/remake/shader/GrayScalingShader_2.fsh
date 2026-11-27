#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()
{
	vec4 normalColor = v_fragmentColor * texture2D(u_texture, v_texCoord);
	float f=(normalColor.r+normalColor.g+normalColor.b)* (1. / 3.);
	gl_FragColor=vec4(f,f,f,normalColor.a);
}
