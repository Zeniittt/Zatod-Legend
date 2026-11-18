using System;
using UnityEngine;
using Zatod.Heroes;

namespace Zatod.Animation
{
    public sealed class HeroModelPreview : MonoBehaviour
    {
        public HeroAnimationPlayer Player { get; private set; }
        public RenderTexture Texture { get; private set; }
        GameObject rig;
        UnityEngine.UI.RawImage image;

        public void Bind(HeroDefinition definition)
        {
            Cleanup();
            var prefab = Resources.Load<GameObject>(definition.BodyPrefabResource);
            if (prefab == null) throw new InvalidOperationException("Missing hero prefab: " + definition.BodyPrefabResource);
            image = gameObject.AddComponent<UnityEngine.UI.RawImage>(); image.raycastTarget = false;
            Texture = new RenderTexture(768, 600, 24, RenderTextureFormat.ARGB32) { name = "HeroModelPreview", filterMode = FilterMode.Point, antiAliasing = 1 };
            Texture.Create(); image.texture = Texture;
            rig = new GameObject("HeroPreviewRig"); rig.transform.position = new Vector3(1000, 1000, 0);
            var model = Instantiate(prefab, rig.transform); model.name = "Preview-" + definition.Id;
            model.transform.localPosition = new Vector3(-1, -1, 0);
            Player = model.GetComponent<HeroAnimationPlayer>();
            HeroAnimationPlayer.SetLayer(model.transform, 31);
            var cameraObject = new GameObject("HeroPreviewCamera", typeof(Camera)); cameraObject.transform.SetParent(rig.transform, false);
            cameraObject.transform.localPosition = new Vector3(.2f, 0, -10);
            var camera = cameraObject.GetComponent<Camera>(); camera.orthographic = true; camera.orthographicSize = 2;
            camera.clearFlags = CameraClearFlags.SolidColor; camera.backgroundColor = Color.clear;
            camera.cullingMask = 1 << 31; camera.targetTexture = Texture; camera.allowHDR = false; camera.allowMSAA = false;
        }

        void Cleanup()
        {
            Player = null;
            if (rig != null) { rig.SetActive(false); Destroy(rig); rig = null; }
            if (image != null) image.texture = null;
            if (Texture != null) { Texture.Release(); Destroy(Texture); Texture = null; }
        }
        void OnDisable() { Cleanup(); }
        void OnDestroy() { Cleanup(); }
    }
}
