#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;

uniform sampler2D CC_Texture0;
uniform vec4 HSV;

void main()
{
    vec4 textureColor = texture2D(CC_Texture0, v_texCoord);
    float r = textureColor.r;
    float g = textureColor.g;
    float b = textureColor.b;
    float a = textureColor.a;

    float h, s, v;
    // Convert RGB to HSV
    float max = max(max(r, g), b);
    float min = min(min(r, g), b);
    float delta = max - min;

    // H
    if (delta == 0.0) {
        h = 0.0;
    } else if (max == r) {
        h = mod((60.0 * (g - b) / delta + 360.0), 360.0);
    } else if (max == g) {
        h = mod((60.0 * (b - r) / delta + 120.0), 360.0);
    } else {
        h = mod((60.0 * (r - g) / delta + 240.0), 360.0);
    }

    // S
    if (max == 0.0) {
        s = 0.0;
    } else {
        s = delta / max;
    }

    // V
    v = max;

    // Adjust HSV values
    h = mod(h + HSV.x * 360.0, 360.0);
    s = clamp(s + HSV.y, 0.0, 1.0);
    v = clamp(v + HSV.z, 0.0, 1.0);

    // Convert HSV back to RGB
    float c = v * s;
    float x = c * (1.0 - abs(mod(h / 60.0, 2.0) - 1.0));
    float m = v - c;
    vec3 rgb;

    if (0.0 <= h && h < 60.0) {
        rgb = vec3(c, x, 0.0);
    } else if (60.0 <= h && h < 120.0) {
        rgb = vec3(x, c, 0.0);
    } else if (120.0 <= h && h < 180.0) {
        rgb = vec3(0.0, c, x);
    } else if (180.0 <= h && h < 240.0) {
        rgb = vec3(0.0, x, c);
    } else if (240.0 <= h && h < 300.0) {
        rgb = vec3(x, 0.0, c);
    } else {
        rgb = vec3(c, 0.0, x);
    }

    rgb += vec3(m);

    gl_FragColor = vec4(rgb, a);
}
