Shader "Unlit/Overlay_Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TintColor ("Tint Color", Color) = (1, 1, 1, 1)
        _OverlayColor("Overlay Color", Color) = (1 ,1 ,1 ,1)
        _Strength("Strength", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Transparent" }
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                fixed4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                fixed4 color : COLOR;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _TintColor;
            float4 _OverlayColor;
            float4 _Strength;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color * _TintColor;
                return o;
            }

            float BlendMode_Overlay(float _TintColor, float _OverlayColor)
            {
                return (_TintColor <= 0.5) ? 2 * _TintColor * _OverlayColor: 1 - 2 * (1 - _TintColor) * (1 - _OverlayColor);
            }

            float3 BlendMode_Overlay(float3 _TintColor, float3 _OverlayColor)
            {
                return float3(BlendMode_Overlay(_TintColor.r, _OverlayColor.r),
                              BlendMode_Overlay(_TintColor.g, _OverlayColor.g),
                              BlendMode_Overlay(_TintColor.b, _OverlayColor.b));
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 baseColor = tex2D(_MainTex, i.uv);
                float3 overlay = BlendMode_Overlay(baseColor.rgb, _OverlayColor.rgb);
                fixed4 finalColor = lerp(baseColor, fixed4(overlay, baseColor.a), _OverlayColor.a);
                finalColor.a = baseColor.a * _OverlayColor.a;
                return finalColor;
            }
            ENDCG
        }
    }
}
