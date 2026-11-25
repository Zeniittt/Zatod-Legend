using System;
using System.Linq;
using System.Globalization;
using System.Text.RegularExpressions;
namespace Zatod.Heroes
{
    public static class SkillDescription
    {
        public static SkillDefinition AtLevel(SkillDefinition source,int level)
        {
            var copy=source.Copy();
            foreach(var growth in copy.Crystal.Growth)
                if(growth.Field.StartsWith("Script Arg",StringComparison.Ordinal) && int.TryParse(growth.Field.Substring(10),out int i) && i>0 && i<=copy.Crystal.ScriptArgs.Count)copy.Crystal.ScriptArgs[i-1]+=(level-1)*growth.Amount;
            SkillEvolution.ApplyParameters(copy,level);return copy;
        }
        public static string Describe(SkillDefinition source,int level,HeroCatalog catalog)
        {
            var skill=AtLevel(source,level);var info=skill.Crystal;
            var buff=catalog.Data.Buffs.FirstOrDefault(x=>x.SourceId==info.BuffId);
            string Number(double v)=>v.ToString("0.##",CultureInfo.InvariantCulture);
            if(info.PassiveStatRatios?.Count>0)
            {
                double amount=info.BasicAmount+info.Growth.Where(x=>x.Field=="Basic Num").Sum(x=>(level-1)*x.Amount);
                string audience=info.ActiveType=="passive"?"Grants ":"Grants the team ";
                string text=audience+string.Join(", ",info.PassiveStatRatios.Select(x=>Number(amount*x.Value)+" "+(catalog.Data.Stats.FirstOrDefault(s=>s.Id==x.StatId)?.Name??x.StatId.Replace('_',' '))))+".";
                if(info.PassiveExtraDamageTargets?.Count>0)
                {
                    var names=catalog.Data.Heroes.Where(h=>info.PassiveExtraDamageTargets.Contains(h.SourceUnitId)).Select(h=>h.Name).ToArray();
                    if(names.Length>0)text+=" Also grants "+Number(amount)+" Physical Attack to "+string.Join(", ",names)+".";
                }
                return text;
            }
            string value=Regex.Replace(source.Description??source.Name,@"%(Skill|Buff)&([^%]+)%",m=>
            {
                string field=m.Groups[2].Value;double number=0;
                if(m.Groups[1].Value=="Skill")
                {
                    if(field=="Basic Num")number=info.BasicAmount+info.Growth.Where(x=>x.Field==field).Sum(x=>(level-1)*x.Amount);
                    else if(field=="Plus Ratio")number=info.PlusRatio;
                    else if(field.StartsWith("Script Arg") && int.TryParse(field.Substring(10),out int i) && i>0 && i<=info.ScriptArgs.Count)number=info.ScriptArgs[i-1];
                    else if(field=="CD")number=info.Cooldown;
                    else if(field=="Gain MP")number=info.GainEnergy;
                    else if(field=="Passive Attr")return ZatodStatName(info.PassiveAttribute);
                    else if(info.Summon?.Enabled==true)
                    {
                        number=field switch
                        {
                            "SummonCount"=>info.Summon.Count,
                            "SummonDurationSeconds"=>info.Summon.DurationSeconds,
                            "SummonHealthMultiplier"=>info.Summon.HealthMultiplier,
                            "SummonDamageMultiplier"=>info.Summon.DamageMultiplier,
                            _=>0
                        };
                    }
                }
                else if(buff!=null)
                {
                    var changes=SkillEvolution.Active(source,level).SelectMany(x=>x.ParameterChanges).Where(x=>x.BuffId==0 || x.BuffId==buff.SourceId);
                    if(field=="Time")
                    {
                        number=buff.Duration+info.Growth.Where(x=>x.Field=="Time").Sum(x=>(level-1)*x.Amount);
                        foreach(var p in changes)
                            if(p.Field=="BuffDuration")number=p.Mode==SkillParameterMode.Add?number+p.Value:p.Value;
                            else if(p.Field=="BuffDurationBonus")number+=p.Value;
                    }
                    else if(field=="Shield Value")
                    {
                        number=buff.ShieldValue+info.Growth.Where(x=>x.Field==field).Sum(x=>(level-1)*x.Amount);
                        foreach(var p in changes.Where(x=>x.Field=="ShieldBonus"))number=p.Mode==SkillParameterMode.Add?number+p.Value:p.Value;
                    }
                    else
                    {
                        bool scaling=field.EndsWith(".a",StringComparison.Ordinal);string id=ZatodStatName(scaling?field.Substring(0,field.Length-2):field);
                        number=scaling?(buff.Scaling.FirstOrDefault(x=>x.StatId==id)?.Ratio??0):(buff.Stats.FirstOrDefault(x=>x.StatId==id)?.Value??0)+info.Growth.Where(x=>x.Field==field).Sum(x=>(level-1)*x.Amount);
                        foreach(var p in changes.Where(x=>x.Field=="BuffStat" && x.StatId==id))
                        {double change=scaling?p.ScalingRatio:p.Value;number=p.Mode==SkillParameterMode.Add?number+change:change;}
                    }
                }
                return Number(number);
            });
            value=Regex.Replace(value,@"<#\d+#(.*?)#>","$1");
            value=Regex.Replace(value,@"</?lable[^>]*>","");
            return value.Replace("#p#","%").Replace("\\n","\n");
        }
        public static string ZatodStatName(string name)
        {
            switch(name)
            {
                case "HP":return "health";case "AD":return "damage";case "AP":return "ability_power";case "ARM":return "defense";case "MR":return "magic_resistance";
                case "HPR":return "health_regen";case "MPR":return "energy_regen";case "HAST":return "haste";case "MSPD":return "action_speed";case "PIMU":return "physical_immunity";case "MIMU":return "magic_immunity";case "LFS":return "lifesteal";case "CRIT":return "physical_crit";case "TEN":return "tenacity";case "HIT":return "accuracy";default:return (name??"").ToLowerInvariant();
            }
        }
    }
}
