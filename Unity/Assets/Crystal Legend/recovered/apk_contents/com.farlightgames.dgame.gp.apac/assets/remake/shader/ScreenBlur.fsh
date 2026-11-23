#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform sampler2D CC_Texture0;

uniform vec2 blurSize;
uniform vec2 uCanvasSize;

void main() {
	float weights[9];
	weights[0] = 0.05;
    weights[1] = 0.09;
    weights[2] = 0.12;
    weights[3] = 0.15;
    weights[4] = 0.18;
    weights[5] = 0.15;
    weights[6] = 0.12;
    weights[7] = 0.09;
    weights[8] = 0.05;
    vec2 texOffset = 1.0 / uCanvasSize;
    vec4 color = vec4(0.0);
	for (int i = 0; i < 9; i++) {
		for (int j = 0; j < 9; j++) {
			vec2 offset = vec2(float(i - 9 / 2), float(j - 9 / 2)) * texOffset * blurSize.x;
			color += texture2D(CC_Texture0, v_texCoord + offset) * weights[i] * weights[j];
		}
	}
    gl_FragColor = color;
}