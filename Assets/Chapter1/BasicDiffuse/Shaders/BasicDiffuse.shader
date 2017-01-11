Shader "CookbookShaders/BasicDiffuse" {
	Properties {
		_RampTex ("Base (RGB)", 2D) = "white" {}
		_EmmisiveColor ("Emmisive Color", Color) = (1,1,1,1)
		_AmbientColor ("Ambient Color", Color) = (1,1,1,1)
		_MySliderValue ("My Slider Value", Range(0,10)) = 2.5
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf BasicDiffuse

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		sampler2D _RampTex;

		struct Input {
			float2 uv_MainTex;
		};

		float4 _EmmisiveColor;
		float4 _AmbientColor;
		float _MySliderValue;

		void surf (Input IN, inout SurfaceOutput o) {
			float4 c;
			c = pow((_EmmisiveColor + _AmbientColor), _MySliderValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		inline float4 LightingBasicDiffuse (SurfaceOutput s, fixed3 lightDir, fixed atten) {
			float diffLight = dot(s.Normal, lightDir);
			float hLambert = diffLight * 0.5 + 0.5;
			float3 ramp = tex2D(_RampTex, float2(hLambert, hLambert)).rgb;

			float4 col;
			col.rgb = s.Albedo * _LightColor0.rgb * (ramp);
			col.a = s.Alpha;
			return col;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
