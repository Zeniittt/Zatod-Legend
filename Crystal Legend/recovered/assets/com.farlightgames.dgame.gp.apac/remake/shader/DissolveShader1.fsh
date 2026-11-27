#ifdef GL_ES
precision mediump float;
#endif

varying vec4 v_fragmentColor;
varying vec2 v_texCoord;
uniform sampler2D CC_Texture0;
uniform sampler2D CC_Texture1;
uniform vec2 u_alphakey;

void main()
{
    vec4 color = texture2D(CC_Texture0, v_texCoord);
    vec4 color_mask = texture2D(CC_Texture1, v_texCoord);
    if(color_mask.r > u_alphakey.x){
        gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
    }else{
        gl_FragColor = color;
    }
}
