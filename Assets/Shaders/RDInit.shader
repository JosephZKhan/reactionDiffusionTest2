Shader "Custom/RDInit"
{
    Properties
    {
        _Seed("Seed", Range(0, 1)) = 0
    }

    CGINCLUDE

    #include "UnityCustomRenderTexture.cginc"

    half _Seed;

    //generate a random float value for the entered float2 value UV
    float randUVs(float2 uv)
    {
        return frac(sin(dot(uv, float2(12.9898, 78.233))) * 43758.5453);
        //return random value between 0 and 1
    }

    half4 frag(v2f_init_customrendertexture i) : SV_Target
    {
        float randVal = randUVs(i.texcoord) + randUVs(i.texcoord + 1);
        return half4(1, step(randVal, _Seed * 0.1), 0, 0);
        //step returns 1 if randVal > _Seed * 0.1, and 0 otherwise
    }

    ENDCG

    SubShader
    {
        Cull Off ZWrite Off ZTest Always    //optimization
        Pass
        {
            Name "Init"
            CGPROGRAM
            #pragma vertex InitCustomRenderTextureVertexShader
            #pragma fragment frag
            ENDCG
        }
    }
}
