// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'
// UNITY_SHADER_NO_UPGRADE 
Shader "Unity Shaders Book/Chapter 8/Blend Operations 1"
{
    Properties
    {
        _Color ("Color Tint", Color) = (1, 1, 1, 1)
        _MainTex ("Main Tex", 2D) = "white" {}
        _AlphaScale ("Alpha Scale", Range(0, 1)) = 1
        [PowerSlider(3.0)] _EdgePow("Edge Pow", Range(0.5, 10)) = 1
        [PowerSlider(3.0)] _EdgeMultiple("Edge Multiple", Range(0.5, 10)) = 1
    }
    SubShader
    {
        //		Tags {"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Transparent"}

        Pass
        {
            //			Tags { "LightMode"="ForwardBase" }

            //			ZWrite Off

            //			// Normal
            //			Blend SrcAlpha OneMinusSrcAlpha
            //			
            //			// Soft Additive
            //			Blend OneMinusDstColor One
            //			
            //			// Multiply
            //			Blend DstColor Zero
            //			
            //			// 2x Multiply
            //			Blend DstColor SrcColor
            //			
            //			// Darken
            //			BlendOp Min
            //			Blend One One	// When using Min operation, these factors are ignored
            //			
            //			//  Lighten
            //			BlendOp Max
            //			Blend One One // When using Max operation, these factors are ignored
            //			
            //			// Screen
            //			Blend OneMinusDstColor One
            // Or
            //			Blend One OneMinusSrcColor
            //			
            //			// Linear Dodge
            //			Blend One One

            // Premultiplied transparency
            //			Blend SrcAlpha OneMinusSrcAlpha

            //			ColorMask 0

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "Lighting.cginc"
            #include "UnityCG.cginc"

            fixed4 _Color;
            // sampler2D _MainTex;
            UNITY_DECLARE_TEX2D(_MainTex);
            float4 _MainTex_ST;
            fixed _AlphaScale;
            sampler2D _CameraDepthTexture;
            float _EdgePow, _EdgeMultiple;

            struct a2v : appdata_base
            {
                // float4 vertex : POSITION;
                // float3 normal : NORMAL;
                // float4 texcoord : TEXCOORD0;
            };

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
                float4 screenPos : TEXCOORD1;
                float3 normal : TEXCOORD2;
                float3 viewDir : TEXCOORD3;
                float4 test : POSITION1;
            };

            v2f vert(a2v v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                o.screenPos = ComputeScreenPos(o.pos);
                o.normal = UnityObjectToWorldNormal(v.vertex);
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));
                o.test = o.pos; // / o.pos.w;
                // float4 tt = o.pos * 0.5f;
                // tt.xy = float2(tt.x, tt.y*_ProjectionParams.x) + tt.w;
                // tt.zw = o.pos.zw;
                // o.test = tt;

                return o;
            }

            float4 frag(v2f i) : SV_Target
            {
                // fixed4 texColor = tex2D(_MainTex, i.uv);
                fixed4 texColor = UNITY_SAMPLE_TEX2D(_MainTex, i.uv);
                float2 screenUV = i.screenPos.xy / i.screenPos.w;
                screenUV = (i.test.xy / i.test.w) * 0.5f + 0.5f; screenUV.y = 1-screenUV.y;
                // screenUV = i.test.xy / i.test.w;
                float depth = Linear01Depth(SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, screenUV));
                half3 depthColor = lerp(half3(0, 0, 0), _Color, depth);
                float fresnel = pow(1 - max(0, dot(i.normal, i.viewDir)), _EdgePow) * _EdgeMultiple;
                half3 finalColor = lerp(depthColor, texColor, fresnel);

                // cross(texColor, texColor);

                // return fixed4(texColor.rgb * _Color.rgb, texColor.a * _AlphaScale);

                // float a = UNITY_MATRIX_P[3].z + 2.5;
                // float a = i.pos.y / _ScreenParams.y;
                // a = i.test.x / i.test.w * 0.5f + 0.5f;


                return fixed4(finalColor, 1);
                // float3x3 mTest = float3x3(
                //       1, 0, 0
                //     , 2, 0, 0
                //     , 3, 0, 0
                // );
                // float3 vTest = float3(1, 0, 0);
                // float3 rTest = mul(mTest, vTest);
                // return fixed4(UNITY_MATRIX_P[3][2] + 1.1, 0, 0, 1);
            }
            ENDCG
        }
    }
    FallBack "Transparent/VertexLit"
}