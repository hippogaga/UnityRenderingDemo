﻿Shader "ShaderLearning/SpecularVertex" {
	Properties{
		_Diffuse("Diffuse", Color) = (1,1,1,1)
		_Specular("Specular", Color) = (1, 1, 1, 1)
		_Gloss("Gloss", Range(8, 255)) = 8
	}
	SubShader{
		Pass {
			Tags { "LightMode" = "ForwardBase" }

			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"

			fixed4 _Diffuse;
			fixed4 _Specular;
			float _Gloss;

			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f {
				float4 pos : SV_POSITION;
				fixed3 color : TEXCOORDS0;
			};

			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz;

				fixed3 worldNormal = normalize(mul(unity_ObjectToWorld, v.normal));

				fixed3 worldLight = normalize(_WorldSpaceLightPos0.xyz);

				fixed3 diffuse = _LightColor0.rgb * _Diffuse.rbg * saturate(dot(worldNormal, worldLight));

				fixed3 reflectDir = normalize(reflect(worldLight, worldNormal));

				fixed3 view = normalize(mul(unity_ObjectToWorld, v.vertex).xyz - _WorldSpaceCameraPos.xyz);

				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(saturate(dot(reflectDir, view)), _Gloss);

				o.color = ambient + diffuse + specular;

				return o;
			}

			fixed4 frag(v2f i) : SV_Target{
				return fixed4(i.color, 1.0);
			}

		ENDCG
		}
	}
	FallBack "Specular"
}
