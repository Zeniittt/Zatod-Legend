#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()
{
    vec4 normalColor = v_fragmentColor * texture2D(u_texture, v_texCoord);
    normalColor.r = normalColor.r ;
    normalColor.g = normalColor.g ;
    normalColor.b = normalColor.b ;
	normalColor.a = normalColor.a * 0.7;
	
    gl_FragColor = normalColor;
}

