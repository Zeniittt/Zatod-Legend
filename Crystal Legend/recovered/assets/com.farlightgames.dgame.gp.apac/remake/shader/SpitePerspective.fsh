varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

uniform vec4 color;
void main()
{
    vec4 texColor = texture2D(u_texture, v_texCoord);
    gl_FragColor = texColor * v_fragmentColor;
}
