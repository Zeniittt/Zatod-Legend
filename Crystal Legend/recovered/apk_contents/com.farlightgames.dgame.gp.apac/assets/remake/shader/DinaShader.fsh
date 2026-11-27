#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()
{
    vec4 normalColor = v_fragmentColor * texture2D(u_texture, v_texCoord);
    normalColor.r = normalColor.r * 0.97;
    normalColor.g = normalColor.g * 0.8;
    normalColor.b = normalColor.b * 0.89;
	normalColor.a = normalColor.a * 0.45;
	
    gl_FragColor = normalColor;
}

