attribute vec4 a_position;
attribute vec2 a_texCoord;
attribute vec4 a_color;

uniform vec4 clipRect;
uniform vec2 softness;
uniform vec2 screenSize;

#ifdef GL_ES
varying lowp vec4 v_fragmentColor;
varying mediump vec2 v_texCoord;
varying lowp vec4 softnessVec;
varying mediump vec2 temVec;
#else
varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
varying vec4 softnessVec;
varying vec2 temVec;
#endif

void main()
{
	gl_Position = CC_MVPMatrix * a_position;
	v_fragmentColor = a_color;
	v_texCoord = a_texCoord;

	vec2 bottomLeft = (CC_PMatrix * vec4(clipRect.x, clipRect.y, 0.0, 1.0)).xy;
	vec2 topRight = (CC_PMatrix * vec4(clipRect.z, clipRect.w, 0.0, 1.0)).xy;
    vec2 pixelSize = vec2(gl_Position.w);
    pixelSize /= vec2(1.0, 1.0) * abs((CC_PMatrix * vec4(screenSize.x, screenSize.y, 0.0, 1.0)).xy);
	softnessVec = vec4(gl_Position.xy * 2.0 - bottomLeft - topRight, 0.25 / (0.25 * softness + abs(pixelSize.xy)));
	temVec = topRight - bottomLeft;
}