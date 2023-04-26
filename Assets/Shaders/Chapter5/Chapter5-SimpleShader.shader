// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unity Shaders Book/Chapter 5/Simple Shader" {
	Properties {
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		[Gamma] _MyColor ("My Color", Vector) = (255, 255, 255, 255)
		[Toggle(ENABLE_EXAMPLE_FEATURE)] _ExampleFeatureEnabled ("Enable example feature", Float) = 0
		[ToggleOff(DISABLE_EXAMPLE_FEATURE2)] _ExampleFeature2Enabled ("Enable example feature2", Float) = 0
		[Enum(One,1, SrcAlpha,5)] _TestEnum ("TestEnum", Float) = 1
		[KeywordEnum(None, Add, Multiply)] _Overlay ("Overlay mode", Float) = 0
		[Enum(WDJ.MyEnum)] _MyEnum ("My Enum", Float) = 1
		[PowerSlider(3.0)] _Shininess ("Shininess", Range (-0.01, 1)) = 0.08
		[IntRange] _Alpha ("Alpha", Range (-1, 255)) = 100
		[Header(A group of things)][Space] _Prop1 ("Prop1", Float) = 0
//		_OffsetUnitScale ("Offset unit scale", Integer) = 1
	}
	SubShader {
		Tags { "Queue" = "Transparent"}
        Pass {
            CGPROGRAM

            #pragma multi_compile __ ENABLE_EXAMPLE_FEATURE
            #pragma shader_feature DISABLE_EXAMPLE_FEATURE2

            #pragma multi_compile _OVERLAY_NONE _OVERLAY_ADD
            #pragma shader_feature _OVERLAY_MULTIPLY
            
            #pragma vertex vert
            #pragma fragment frag
            
            uniform fixed4 _Color;
            uniform fixed4 _MyColor;

            uniform int _TestEnum;

            uniform bool _ExampleFeatureEnabled;
            uniform bool _ExampleFeature2Enabled;
            uniform int _Overlay;
            uniform int _MyEnum;

			struct a2v {
                float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
            };
            
            struct v2f {
                float4 pos : SV_POSITION;
                fixed3 color : COLOR0;
            };
            
            v2f vert(a2v v) {
            	v2f o;
            	o.pos = UnityObjectToClipPos(v.vertex);
            	o.color = v.normal * 0.5 + fixed3(0.5, 0.5, 0.5);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target {
            	fixed3 c = i.color;
	            switch (_MyEnum)
	            {
	            case 1:
	            	c *= 0.5;
	            	break;
	            }
            	#if ENABLE_EXAMPLE_FEATURE
            	#ifndef DISABLE_EXAMPLE_FEATURE2
            	#if _OVERLAY_MULTIPLY
            	// if (_TestEnum == 5)
            	if (_ExampleFeatureEnabled && _ExampleFeature2Enabled)
            	// if (_Overlay == 2)
            		c *= _Color.rgb;
            	#endif
            	#endif
            	#endif
                return fixed4(c, 1.0);
            }

            ENDCG
        }
    }
}
