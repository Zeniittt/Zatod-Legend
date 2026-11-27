#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

uniform vec4 color;
void main()
{
    vec4 normalColor = v_fragmentColor * texture2D(u_texture, v_texCoord);
    if (normalColor.a == 0.0) {
	    gl_FragColor = vec4(0, 0, 0, 0);
	} else {
        gl_FragColor = vec4(color.r * normalColor.r, color.g * normalColor.g, color.b * normalColor.b, color.a * normalColor.a);
	}

}
