#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform sampler2D CC_Texture0;
uniform vec2 resolution;
uniform vec2 circleCenter;
uniform vec2 radius;
uniform vec2 virtualRadius;

void main()
{
	vec2 pos = vec2(v_texCoord.x * resolution.x, (1.0 - v_texCoord.y) * resolution.y);
	float dis = (pos.x - circleCenter.x) * (pos.x - circleCenter.x) + (pos.y - circleCenter.y) * (pos.y - circleCenter.y);
	float radiusDis = radius.x * radius.x;
	float virtualDis = virtualRadius.x * virtualRadius.x;
	if (dis <= radiusDis){	
		if ((radiusDis - dis) >= virtualDis){
			gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord);
		}else{
			gl_FragColor = v_fragmentColor * texture2D(CC_Texture0, v_texCoord) * (radiusDis - dis) / virtualDis;
		}
	}else{
		gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
	}

}
