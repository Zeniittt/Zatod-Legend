using System.Collections.Generic;
using System.Linq;
using Zatod.Heroes;

namespace Zatod.Combat
{
    public sealed partial class ZatodBattleSimulation
    {
        sealed class Region
        {
            public Unit Caster;
            public BattleSkillData Skill;
            public int BirthTick;
            public double X,Y,Remaining;
            public double Elapsed;
            public string VisualResource;
            public int VisualId;
            public readonly Dictionary<int,ActiveBuff> Applied=new Dictionary<int,ActiveBuff>();
        }
        readonly List<Region> regions=new List<Region>();
        void CreateRegion(Unit actor,Unit target,BattleSkillData skill)
        {
            // Crystal's region identity consumes the shared random stream.
            Random();
            regions.Add(new Region{Caster=actor,Skill=skill,X=target.State.X,Y=target.State.Y,
                Remaining=Arg(skill.Definition.Crystal,1),BirthTick=tick});
        }
        void ClearRegions()
        {
            foreach(var region in regions)
                foreach(var pair in region.Applied)
                {
                    var unit=Find(pair.Key);
                    if(unit!=null)RemoveEvolutionBuff(unit,pair.Value,false);
                }
            regions.Clear();
        }
        void AdvanceRegions()
        {
            if(!ExpandedRules)return;
            foreach(var region in regions.ToArray())
            {
                if(region.BirthTick==tick)continue;
                region.Remaining-=StepSeconds;
                region.Elapsed+=StepSeconds;
                var info=region.Skill.Definition.Crystal;
                if(info.SourceId==24902 && (!region.Caster.State.Alive || region.Caster.Summoner?.State.Alive!=true))region.Remaining=-1;
                var inside=region.Remaining<0?new HashSet<int>():new HashSet<int>(
                    Affected(region.Caster,region.Caster,info,region.X,region.Y)
                    .Where(u=>!Controlled(u,"invulnerable") && (info.SourceId!=24902 || u.Summoner==null && u.State.X>=0 && u.State.X<=800)).Select(u=>u.State.EntityId));
                foreach(var pair in region.Applied.ToArray())
                {
                    var unit=Find(pair.Key);
                    if(unit==null || !unit.Buffs.Contains(pair.Value)){region.Applied.Remove(pair.Key);continue;}
                    if(region.Remaining<0 || !Controlled(unit,"invulnerable") && !inside.Contains(pair.Key))
                    {RemoveEvolutionBuff(unit,pair.Value,false);region.Applied.Remove(pair.Key);}
                }
                if(region.Remaining<0){regions.Remove(region);continue;}
                foreach(int id in inside.OrderBy(i=>i))
                {
                    if(region.Applied.ContainsKey(id))continue;
                    var unit=Find(id);
                    ApplyBuff(region.Caster,unit,region.Skill);
                    var added=unit.Buffs.LastOrDefault(b=>b.CasterId==region.Caster.State.EntityId && b.Definition.SourceId==info.BuffId);
                    if(added!=null)region.Applied[id]=added;
                }
            }
        }
    }
}
