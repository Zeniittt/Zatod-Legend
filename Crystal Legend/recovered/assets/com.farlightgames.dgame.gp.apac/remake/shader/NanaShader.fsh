#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

void main()
{

    vec4 normalColor = v_fragmentColor * texture2D(u_texture, v_texCoord);
	
	
	gl_FragColor = vec4(normalColor.r, normalColor.g, normalColor.b, normalColor.a)*vec4(255/255,255/255,255/255,0.7);
}

