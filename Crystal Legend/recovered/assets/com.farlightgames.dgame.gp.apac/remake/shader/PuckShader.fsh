#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()
{
    vec4 normalColor = v_fragmentColor * texture2D(u_texture, v_texCoord);
    normalColor.r = normalColor.r * 0.2;
    normalColor.g = normalColor.g * 0.4;
    normalColor.b = normalColor.b * 0.7;
	normalColor.a = normalColor.a * 0.7;
	
    gl_FragColor = normalColor;
}

