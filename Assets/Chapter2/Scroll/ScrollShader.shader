Shader "CookbookShaders/ScrollShader" {
	Properties {
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Albedo (RGB)", 2D) = "white" {}
		_CellAmount("Cell Amount", float) = 0.0
		_Speed("Speed", Range(0.1, 32)) = 12
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 200
		
		CGPROGRAM

		#pragma surface surf Lambert

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0

		float4 _Color;
		sampler2D _MainTex;
		float _CellAmount;
		float _Speed;

		struct Input {
			float2 uv_MainTex;
		};

		void surf (Input IN, inout SurfaceOutput o) {
			float2 spriteUV = IN.uv_MainTex;
			float cellUVPercentage = 1/_CellAmount;
			float frame = fmod(_Time.y * _Speed, _CellAmount);
			frame = floor(frame);

			float xValue = (spriteUV.x + frame) * cellUVPercentage;
			spriteUV = float2(xValue, spriteUV.y);

			half4 c = tex2D(_MainTex, spriteUV);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
	FallBack "Diffuse"
}
