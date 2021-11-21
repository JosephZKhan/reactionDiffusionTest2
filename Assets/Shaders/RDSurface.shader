Shader "Custom/RDSurface"
{
    Properties
    {
        _MainTex("RD Texture", 2D) = "white"{}
        [Space]
        _Color0("Colour A", Color) = (1,1,1,1)
        _Color1("Colour B", Color) = (0,0,0,1)
        [Space]
        _Smoothness0("Smoothness 0", Range(0, 1)) = 0.5
        _Smoothness1("Smoothness 1", Range(0, 1)) = 0.5
        [Space]
        _Metallic0("Metallic 0", Range(0, 1)) = 0.0
        _Metallic1("Metallic 1", Range(0, 1)) = 0.0
        [Space]
        _Threshold("Threshold", Range(0, 1)) = 0.1
        _Fading("Edge Smoothing", Range(0, 1)) = 0.2
        _NormalStrength("Normal Strength", Range(0, 1)) = 0.9

    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        CGPROGRAM
        #pragma surface surf Standard 
        #pragma target 3.0

        sampler2D _MainTex;
        float4 _MainTex_TexelSize;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color0, _Color1;
        half _Smoothness0, _Smoothness1;
        half _Metallic0, _Metallic1;
        half _Threshold, _Fading;
        half _NormalStrength;

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 duv = float3(_MainTex_TexelSize.xy, 0);  
            //converts uv co-ordinates to float3

            half v0 = tex2D(_MainTex, IN.uv_MainTex).y;                 //v of central vertex
            half v1 = tex2D(_MainTex, IN.uv_MainTex - duv.xz).y;        //v of left vertex
            half v2 = tex2D(_MainTex, IN.uv_MainTex + duv.xz).y;        //v of right vertex
            half v3 = tex2D(_MainTex, IN.uv_MainTex - duv.zy).y;        //v of upper vertex
            half v4 = tex2D(_MainTex, IN.uv_MainTex + duv.zy).y;        //v of lower vertex

            half p = smoothstep(_Threshold, _Threshold + _Fading, v0);  
            //interpolates the colour between A/B

            o.Albedo = lerp(_Color0.rgb, _Color1.rgb, p);
            o.Smoothness = lerp(_Smoothness0, _Smoothness1, p);
            o.Metallic = lerp(_Metallic0, _Metallic1, p);               
            //update colour/smooth/metallic values with p

            o.Normal = normalize(float3(v1 - v2, v3 - v4, 1 - _NormalStrength));
            //update surface normals
        }
        ENDCG
    }
    FallBack "Diffuse"
}
