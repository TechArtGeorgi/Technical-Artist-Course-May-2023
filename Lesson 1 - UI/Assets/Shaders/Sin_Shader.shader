Shader "Unlit/Sine_Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Strenght("Strenght", Range(-100, 100)) = 1
        _Magnitude("Magnitude", Range(0, 1)) = 1
        _Frequency ("Frequency ", Range(0,10)) = 1
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
                float4 color : COLOR;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 color : COLOR;

            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Strenght; 
            float _Magnitude;
            float _Frequency;

            v2f vert (appdata v)
            {
                v2f o;
                float4 tempV = UnityObjectToClipPos(v.vertex);
                tempV.x += sin(_Time.x * _Frequency + v.uv.x * _Frequency) * _Strenght * _Magnitude;
                o.vertex = tempV;
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.color = v.color;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 result = i.color * col;

                return result;
            }
            ENDCG
        }
    }
}
