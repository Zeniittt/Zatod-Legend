using System;
using System.Linq;
using UnityEngine;
using Zatod.Heroes;

namespace Zatod.Animation
{
    // Presentation only. Animation/projectile visuals must never decide combat hits or effects.
    [RequireComponent(typeof(Animator))]
    public sealed class HeroAnimationPlayer : MonoBehaviour
    {
        public string HeroId = "leenald";
        public string CurrentState { get; private set; } = "Idle";
        public int SpawnedProjectileCount { get; private set; }
        public HeroAnimationSetData AnimationSet { get; private set; }
        HeroDefinition hero;
        HeroCatalog catalog;
        Animator animator;
        SkillDefinition pendingProjectile;
        float stateStarted;
        SpriteRenderer animatedRenderer, elevatedRenderer;

        void Awake()
        {
            animator = GetComponent<Animator>(); animator.updateMode = AnimatorUpdateMode.UnscaledTime;
            catalog = HeroDataJson.LoadBundledCatalog(); hero = catalog.Hero(HeroId);
            var json = Resources.Load<TextAsset>(hero.AnimationSetResource);
            if (json == null) throw new InvalidOperationException("Missing animation set: " + hero.AnimationSetResource);
            AnimationSet = JsonUtility.FromJson<HeroAnimationSetData>(json.text);
            if (AnimationSet.Clips.Any(c=>c.PresentationHeight!=0))
            {
                animatedRenderer = GetComponent<SpriteRenderer>();
                var child = new GameObject("PresentationSprite",typeof(SpriteRenderer)); child.transform.SetParent(transform,false);
                elevatedRenderer = child.GetComponent<SpriteRenderer>(); elevatedRenderer.sharedMaterial=animatedRenderer.sharedMaterial;
                elevatedRenderer.sortingOrder=animatedRenderer.sortingOrder; animatedRenderer.enabled=false;
            }
        }
        void LateUpdate()
        {
            if(elevatedRenderer==null) return;
            elevatedRenderer.sprite=animatedRenderer.sprite;
            int height=AnimationSet.Clips.FirstOrDefault(c=>c.State==CurrentState)?.PresentationHeight ?? 0;
            elevatedRenderer.transform.localPosition=new Vector3(0,height/(float)HeroProjectileOrigin.CombatUnitsPerWorldUnit,0);
        }

        public void Play(string state)
        {
            if (!AnimationSet.Clips.Any(c => c.State == state && !c.Projectile)) throw new ArgumentException("Unknown hero animation: " + state);
            pendingProjectile = null; CurrentState = state; stateStarted = Time.unscaledTime;
            animator.Play(Animator.StringToHash(state), 0, 0); animator.Update(0);
            var skill = catalog.Data.Skills.FirstOrDefault(s => s.AnimationState == state &&
                (s.Id == hero.NormalAttackSkillId || hero.SkillSlots.Any(slot => slot.SkillId == s.Id)));
            if (skill != null && skill.Delivery == SkillDelivery.Projectile) pendingProjectile = skill;
        }

        void Update()
        {
            if (animator.GetCurrentAnimatorStateInfo(0).IsName("Idle")) CurrentState = "Idle";
            if (pendingProjectile == null || (Time.unscaledTime - stateStarted) * 1000 < pendingProjectile.ProjectileSpawnMilliseconds) return;
            var prefab = Resources.Load<GameObject>(pendingProjectile.ProjectileResource);
            if (prefab == null) throw new InvalidOperationException("Missing projectile visual prefab: " + pendingProjectile.ProjectileResource);
            var projectile = Instantiate(prefab, transform.parent);
            var origin = HeroProjectileOrigin.Resolve(hero.SpawnPoints, pendingProjectile);
            float forward = origin.Forward / (float)HeroProjectileOrigin.CombatUnitsPerWorldUnit;
            float height = origin.Height / (float)HeroProjectileOrigin.CombatUnitsPerWorldUnit;
            projectile.transform.position = transform.TransformPoint(new Vector3(forward, height, 0)); projectile.transform.rotation = transform.rotation;
            projectile.transform.localScale = transform.localScale;
            SetLayer(projectile.transform, gameObject.layer);
            SpawnedProjectileCount++; pendingProjectile = null;
        }

        public void SetFacing(bool right)
        {
            var scale = transform.localScale; scale.x = Mathf.Abs(scale.x) * (right ? 1 : -1); transform.localScale = scale;
        }

        public static void SetLayer(Transform root, int layer)
        {
            root.gameObject.layer = layer;
            foreach (Transform child in root) SetLayer(child, layer);
        }
        void OnDisable() { pendingProjectile = null; }
    }
}
