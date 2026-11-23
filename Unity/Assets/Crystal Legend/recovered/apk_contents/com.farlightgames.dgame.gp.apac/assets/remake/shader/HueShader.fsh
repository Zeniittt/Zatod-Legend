#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform sampler2D CC_Texture0;

uniform mat3 u_hue;

void main()
{
	vec4 textureColor = texture2D(CC_Texture0, v_texCoord);
	vec3 rgbColor = u_hue * textureColor.rgb;
	gl_FragColor = vec4(rgbColor, textureColor.a);
}



