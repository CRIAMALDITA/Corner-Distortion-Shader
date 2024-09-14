
Shader "Custom/CameraVerticalFade"{
    Properties {
        _MainTex ("Texture", 2D) = "white" {}

        [Header(Distort Corners Settings)]_Property(" ", float) = 0
        _TopLeft ("Top Left", Vector) = (0.0, 1.0, 0.0, 0.0)
        _TopRight ("Top Right", Vector) = (1.0, 1.0, 0.0, 0.0)
        _BottomRight ("Bottom Right", Vector) = (1.0, 0.0, 0.0, 0.0)
        _BottomLeft ("Bottom Left", Vector) = (0.0, 0.0, 0.0, 0.0) 

        [Header(Vertical Fade Settings)]_Property(" ", float) = 0
        _FadePoint ("Fade Point", Range(0, 1)) = 0.5
        _FadeRange ("Fade Range", Range(0, 1)) = 0.2
    }
    SubShader {
        Tags { "Queue"="Overlay" "RenderType"="Opaque" }
        LOD 100

        Pass {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag
            #include "UnityCG.cginc"

            float4 _TopLeft;
            float4 _TopRight;
            float4 _BottomRight;
            float4 _BottomLeft;
           
            sampler2D _MainTex; 

            float _FadePoint;
            float _FadeRange;

            struct appdata_t {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f {
                float2 uv : TEXCOORD0;
                float4 pos : SV_POSITION;
            };

            //Apply distort method.
            float2 distortUV(float2 uv, float2 tl, float2 tr, float2 br, float2 bl)
            {
                float2 topInterp = lerp(tl, tr, uv.x);
                float2 bottomInterp = lerp(bl, br, uv.x);
                float2 finalInterp = lerp(bottomInterp, topInterp, uv.y);

                return finalInterp;
            }
            //-------------------------------------------------------------------

            v2f vert_img(appdata_t v) {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag(v2f i) : SV_Target 
            {
               //Set fade Range ----------------------------------
               float2 screenPos = i.uv;

               if (_FadePoint == 0.0) {
                   return float4(1, 0, 0, 1);
               }

               float fadeRange = max(_FadeRange, 0.01); 
               float alpha = 1;

               if(screenPos.y >= _FadePoint)
               {
                   float diff = screenPos.y - _FadePoint;
                   if(diff > 0)
                   {
                       alpha = diff / fadeRange;
                       alpha = 1 - alpha;
                       if(alpha > 1) alpha = 1;
                   }
               }
               //--------------------------------------------------
                
               float2 distortedUV = distortUV(screenPos, _TopLeft.xy, _TopRight.xy, _BottomRight.xy, _BottomLeft.xy); //Apply Distort
                screenPos = distortedUV;

               fixed4 color = tex2D(_MainTex,  screenPos);//Create new pixel with new position.
               color *= alpha; //Apply Alpha filter.          
               return color;
            }
            ENDCG
        }
    }
    FallBack "Diffuse"
}