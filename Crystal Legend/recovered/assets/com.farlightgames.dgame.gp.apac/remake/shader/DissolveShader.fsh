#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D CC_Texture0;
uniform vec2 u_alphakey;
uniform vec2 u_type;

void main()
{
    vec4 color1 = texture2D(CC_Texture0, vec2(v_texCoord.x, v_texCoord.y)) * v_fragmentColor;
	vec4 colormask = texture2D(CC_Texture0, vec2(v_texCoord.x, v_texCoord.y + 0.5));
	float delta = 0.2;
	if(u_type.x == 1.0) {
        float alpha1 = u_alphakey.x + delta;
	    if(v_texCoord.y <= 0.5 && colormask.a < u_alphakey.x)
            gl_FragColor = vec4(color1.r, color1.g, color1.b, color1.a);
        else if(v_texCoord.y <= 0.5 && color1.a > 0.0 && colormask.a >= u_alphakey.x && colormask.a < alpha1) {
            float alpha2 = (alpha1 - colormask.a) / delta;
            if(alpha2 > color1.a) alpha2 = color1.a;
            gl_FragColor = vec4(color1.r * alpha2, color1.g * alpha2, color1.b * alpha2, color1.a * alpha2);
        }
	} else if(u_type.x == 2.0) {
	    float alpha1 = 1.0 - u_alphakey.x - delta;
	    if(v_texCoord.y <= 0.5 && colormask.a > 1.0 - u_alphakey.x)
            gl_FragColor = vec4(color1.r, color1.g, color1.b, color1.a);
        else if(v_texCoord.y <= 0.5 && color1.a > 0.0 && colormask.a <= 1.0 - u_alphakey.x && colormask.a > alpha1) {
            float alpha2 = (colormask.a - alpha1) / delta;
            if(alpha2 > color1.a) alpha2 = color1.a;
            gl_FragColor = vec4(color1.r * alpha2, color1.g * alpha2, color1.b * alpha2, color1.a * alpha2);
        }
	}
}
