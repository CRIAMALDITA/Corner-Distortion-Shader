using UnityEngine;

namespace CameraDistortEffect
{
    [ExecuteInEditMode]
    public class CameraDistortionEffect : MonoBehaviour
    {
        public Material CameraFilter;

        [Header("Distort Settings")]
        [Space(10)]
        [Tooltip("Set (1, 1) for te original value :p")] public Vector2 TopLeftCorner = new Vector2(1, 1);
        [Tooltip("Set (0, 1) for te original value :p")] public Vector2 TopRightCorner = new Vector2(0, 1);
        [Tooltip("Set (0, 0) for te original value :p")] public Vector2 BottomRightCorner = new Vector2(0, 0);
        [Tooltip("Set (1, 0) for te original value :p")] public Vector2 BottomLeftCorner = new Vector2(1, 0);

        [Header("Fade Settings Settings")]
        [Tooltip("Pixels positions are between 0 and 1. Do not use numbers more biggers")][Range(0, 1)] public float VerticalPointIndex;
        [Tooltip("Pixels positions are between 0 and 1. Do not use numbers more biggers")][Range(0, 1)] public float FadeHeight;


        void OnRenderImage(RenderTexture src, RenderTexture dest)
        {
            if (CameraFilter != null)
            {
                CameraFilter.SetVector("_TopLeft", TopLeftCorner);
                CameraFilter.SetVector("_TopRight", TopRightCorner);
                CameraFilter.SetVector("_BottomLeft", BottomLeftCorner);
                CameraFilter.SetVector("_BottomRight", BottomRightCorner);

                CameraFilter.SetFloat("_FadePoint", VerticalPointIndex);
                CameraFilter.SetFloat("_FadeRange", FadeHeight);

                Graphics.Blit(src, dest, CameraFilter);
            }
            else
            {
                Graphics.Blit(src, dest);
            }
        }
    }
}
