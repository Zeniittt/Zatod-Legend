using UnityEngine;

namespace Zatod.Animation
{
    // The sprite frames contain their authored movement. No second movement/physics pass is applied.
    public sealed class ProjectileVisualLifetime : MonoBehaviour
    {
        public float LifetimeSeconds = 1;
        float born;
        void OnEnable() { born = Time.unscaledTime; }
        void Update() { if (Time.unscaledTime - born >= LifetimeSeconds) Destroy(gameObject); }
    }
}
