Shader "Zatod/Native Buff Sprite"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        _Color ("Tint", Color) = (1,1,1,1)
        _NativeBuff ("Native buff shader", Float) = 0
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" "RenderPipeline"="UniversalPipeline" }
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        Cull Off
        ZWrite Off
        Pass
        {
            HLSLPROGRAM
            #pragma vertex Vertex
            #pragma fragment Fragment
            #pragma multi_compile_instancing
            #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/Core2D.hlsl"
            struct Attributes { COMMON_2D_INPUTS half4 color : COLOR; UNITY_SKINNED_VERTEX_INPUTS };
            struct Varyings { COMMON_2D_OUTPUTS half4 color : COLOR; };
            #include "Packages/com.unity.render-pipelines.universal/Shaders/2D/Include/2DCommon.hlsl"
            CBUFFER_START(UnityPerMaterial)
                half4 _Color;
                float _NativeBuff;
            CBUFFER_END
            Varyings Vertex(Attributes input)
            {
                UNITY_SKINNED_VERTEX_COMPUTE(input);
                SetUpSpriteInstanceProperties();
                input.positionOS=UnityFlipSprite(input.positionOS,unity_SpriteProps.xy);
                Varyings output=CommonUnlitVertex(input);
                output.color=input.color*_Color*unity_SpriteColor;
                return output;
            }
            half4 Fragment(Varyings input) : SV_Target
            {
                half4 color=CommonUnlitFragment(input,input.color);
                // Direct translations of the selected source .fsh files.
                int mode=(int)_NativeBuff;
                if(mode==1) { color*=half4(.8,1,.8,1);color.b+=color.a*.2; }
                else if(mode==2) { color.rgb*=.8;color.r+=.08*color.a;color.g+=.2*color.a; }
                else if(mode==3) { half gray=(color.r+color.g+color.b)/3;color=half4(gray*.9,gray*1.2,gray*.8,color.a*(gray+.1)); }
                else if(mode==4) { half gray=.6*(color.r+color.g+color.b)/3;color=half4(gray,gray,gray,color.a); }
                else if(mode==5) { half gray=1.5*(color.r+color.g+color.b)/3;color=half4(gray*.8,gray*1.2,gray*1.5,color.a); }
                else if(mode==6) { half gray=(color.r+color.g+color.b)/1.8;color=half4(gray,gray*.75,gray*.1,color.a); }
                else if(mode==7) color=0;
                else if(mode==8) { color.r=color.r*1.4+.08*color.a;color.g+=.2*color.a; }
                else if(mode==9) color.a*=.7;
                else if(mode==10) { color.r*=.5;color.g*=.8;color.b+=color.a*.2; }
                return color;
            }
            ENDHLSL
        }
    }
}
