#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

uniform vec4 startColor;
uniform vec4 endColor;
uniform vec2 startPos;
uniform vec2 endPos;

void main()
{
	vec4 textureColor = texture2D(u_texture, v_texCoord);
	float k = 0.0;
	if (endPos.y - startPos.y != 0.0){
		k = v_texCoord.y;
	}
	float r = endColor.r * k + (1.0 - k) * startColor.r;
	float g = endColor.g * k + (1.0 - k) * startColor.g;
	float b = endColor.b * k + (1.0 - k) * startColor.b;
	float a = endColor.a * k + (1.0 - k) * startColor.a;
	gl_FragColor =  v_fragmentColor * textureColor * vec4(r / 255.0, g / 255.0, b / 255.0, 1.0);

}
