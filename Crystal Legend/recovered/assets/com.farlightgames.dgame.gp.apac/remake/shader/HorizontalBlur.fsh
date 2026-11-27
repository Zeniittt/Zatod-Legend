#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D u_texture;

uniform vec2 blurCoeff;

void main()
{
    vec4 color = vec4(0.0, 0.0, 0.0, 0.0);
    float cnt = 0.0;
    float halfBlur = blurCoeff.x * 0.5;
    for(float i = -halfBlur; i <= halfBlur; i+=1.0)
    {
        vec4 newcolor = texture2D(u_texture, vec2(v_texCoord.x + i/blurCoeff.y, v_texCoord.y));
        //float coeff = step(0.01, newcolor.a);
        float coeff = 1.0;
        cnt=cnt+1.0*coeff;
        color = color + newcolor*coeff;
    }
    color = color/max(cnt, 1.0);
    gl_FragColor = color;
}
