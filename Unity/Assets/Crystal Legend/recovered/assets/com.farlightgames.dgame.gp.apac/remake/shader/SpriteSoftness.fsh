#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D CC_Texture0;

varying vec4 softnessVec;
varying vec2 temVec;

uniform vec2 modifyRGB;

void main()
{
	gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);

   	vec2 m = (temVec - abs(softnessVec.xy)) * softnessVec.zw;
   	float a = clamp(m.x, 0.0, 1.0) * clamp(m.y, 0.0, 1.0); 

    gl_FragColor.a *= a;
    float a2 = mix(1.0, a, modifyRGB.x);
    gl_FragColor.rgb *= a2;
}
