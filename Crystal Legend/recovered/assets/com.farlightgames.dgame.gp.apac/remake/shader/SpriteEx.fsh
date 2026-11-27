#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D CC_Texture0;
uniform sampler2D CC_Texture1; //u_mask
uniform sampler2D CC_Texture2; //u_noise
uniform vec3 v_noiseParam;

void main()
{
	vec4 mask = texture2D(CC_Texture1, v_texCoord); //u_mask

	// float _NoiseSpeedX = -1.35;
	// float _NoiseSpeedY = 0;
	// float _NoiseIntensity = 1.15;

	float _noiseIntensity = v_noiseParam.z;

	float timer = CC_Time.x;
	vec2 uv = v_texCoord + timer * v_noiseParam.xy;

    // vec2 newUV = uv * _NoiseTex_ST.xy + _NoiseTex_ST.zw;
    vec2 newUV = fract(uv);
    vec4 noiseColor = tex2D(CC_Texture2, newUV); //u_noise
    noiseColor = (noiseColor * 2 - 1) * 0.005;

    // gl_FragColor = texture2D(CC_Texture0, v_texCoord) * v_fragmentColor;
    gl_FragColor = texture2D(CC_Texture0, v_texCoord + noiseColor.xy * _noiseIntensity * mask.r) * v_fragmentColor;
}
