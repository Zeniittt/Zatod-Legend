using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using UnityEngine;
using Zatod.Animation;
using Zatod.Combat;
using Zatod.Heroes;
namespace Zatod.Presentation
{
    // Holds the actual match's dependencies through loading and scene teardown.
    public sealed class ZatodBattleAssets:IDisposable
    {
        readonly List<UnityEngine.Object> retained=new List<UnityEngine.Object>();
        readonly HashSet<string> paths=new HashSet<string>(StringComparer.Ordinal);
        public readonly List<string> Effects=new List<string>(),MissingAudio=new List<string>();
        public string BattleId{get;private set;}public int Count=>retained.Count;
        T Load<T>(string path,bool required=true) where T:UnityEngine.Object
        {
            var asset=Resources.Load<T>(path);
            if(asset==null && required)throw new FileNotFoundException("Battle asset is missing: "+path);
            if(asset!=null && paths.Add(path))retained.Add(asset);return asset;
        }
        void Audio(string resource)
        {
            if(string.IsNullOrEmpty(resource))return;
            string path="Zatod/Audio/"+Path.GetFileNameWithoutExtension(resource);
            if(Load<AudioClip>(path,false)==null && !MissingAudio.Contains(path))MissingAudio.Add(path);
        }
        void Animation(string resource,bool effect=false)
        {
            if(string.IsNullOrEmpty(resource) || paths.Contains(resource))return;
            var text=Load<TextAsset>(resource);var data=JsonUtility.FromJson<HeroAnimationSetData>(text.text);
            if(effect)Effects.Add(resource);
            foreach(var clip in data.Clips){Load<AnimationClip>(clip.ClipResource);foreach(var cue in clip.AudioCues??new List<HeroAudioCue>())Audio(cue.Resource);}
        }
        void Effect(string resource){if(!string.IsNullOrEmpty(resource))Animation("Zatod/"+Path.GetFileNameWithoutExtension(resource)+"/AnimationSet",true);}
        void Skill(SkillDefinition definition)
        {
            var skill=definition?.Crystal;if(skill==null)return;
            foreach(var resource in new[]{skill.ImpactEffect,skill.LaunchEffect,skill.PointEffect})Effect(resource);
            if(skill.TrackType=="projectile")Effect(skill.ProjectileArt);
            if(skill.TrackType=="chain")Effect(skill.ChainEffect);
            foreach(var resource in skill.AdditionalEffectResources??new List<string>())Effect(resource);
            if(skill.NativeForm?.Enabled==true)Animation(skill.NativeForm.AnimationSetResource);
            foreach(var form in skill.Summon?.Forms??new List<ZatodBattleFormDefinition>())if(form.Enabled)Animation(form.AnimationSetResource);
        }
        public static ZatodBattleAssets Prepare(ZatodMatchDefinition match)
        {
            var result=new ZatodBattleAssets{BattleId=match.BattleId};
            try
            {
                var actors=match.Players.Concat(match.SummonUnits).Concat(match.Waves.SelectMany(w=>w.Enemies)).ToArray();
                foreach(var actor in actors)
                {result.Animation(actor.AnimationSetResource);result.Skill(actor.Battle.NormalAttack);foreach(var skill in actor.Battle.Skills)result.Skill(skill.Definition);}
                var required=new HashSet<string>(actors.SelectMany(a=>a.Battle.Skills.SelectMany(s=>s.Definition.Evolutions??new List<SkillEvolutionDefinition>())).SelectMany(e=>e.TriggeredEffects).Where(e=>!string.IsNullOrEmpty(e.SkillId)).Select(e=>e.SkillId),StringComparer.Ordinal);
                foreach(var skill in match.SkillDependencies.Where(s=>required.Contains(s.Id) || actors.Any(a=>s.Id.StartsWith(a.DefinitionId+"_",StringComparison.Ordinal))))result.Skill(skill);
                foreach(var buff in match.Buffs){result.Effect(buff.Effect);result.Effect(buff.ImpactEffect);}
                foreach(var wave in match.Waves)if(!string.IsNullOrEmpty(wave.Background))result.Load<Texture2D>("Zatod/Backgrounds/"+Path.GetFileNameWithoutExtension(wave.Background));
                result.Audio(match.MusicResource);return result;
            }
            catch{result.Dispose();throw;}
        }
        public void Dispose(){retained.Clear();paths.Clear();Effects.Clear();MissingAudio.Clear();}
    }
}
