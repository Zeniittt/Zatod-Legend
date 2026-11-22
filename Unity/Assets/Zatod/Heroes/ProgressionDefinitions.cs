using System;
using System.Collections.Generic;
using System.Linq;

namespace Zatod.Heroes
{
    // Persisted values: append new currencies; never renumber existing entries.
    public enum CurrencyType { Gold = 0 }
    [Serializable] public sealed class PlayerLevelDefinition
    { public int Level, MaxHeroLevel, MaxStamina, StaminaReward; public long NextLevelExp; }
    [Serializable] public sealed class HeroLevelDefinition { public int Level; public long NextLevelExp; }
    [Serializable] public sealed class ProgressionDefinition
    {
        public int SchemaVersion=1; public string ConfigVersion="zatod-progression-1";
        public int MaxPlayerLevel=100, StaminaRecoverySeconds=360, InitialGold, InitialStamina=60;
        public List<PlayerLevelDefinition> PlayerLevels=new List<PlayerLevelDefinition>();
        public List<HeroLevelDefinition> HeroLevels=new List<HeroLevelDefinition>();
    }
    [Serializable] public sealed class ExperienceChange
    { public string HeroId; public int BeforeLevel,AfterLevel; public long BeforeExp,AfterExp,BeforeRequired,AfterRequired,Granted; }
    [Serializable] public sealed class EconomyBattleReceipt
    {
        public string BattleId,StageId; public long Gold; public int StaminaSpent;
        public ExperienceChange Player; public List<ExperienceChange> Heroes=new List<ExperienceChange>();
        public List<ItemData> Items=new List<ItemData>();
    }
    public static class CurrencyBalance
    {
        // Id is retained only for reading older owned files. New code uses Type.
        public static Currency Gold(CharacterData a)
        {
            a.Currencies=a.Currencies??new List<Currency>();
            var entries=a.Currencies.Where(c=>c.Type==CurrencyType.Gold && (string.IsNullOrEmpty(c.Id)||c.Id=="gold"||c.Id=="money")).ToList();
            if(entries.Count>1)throw new ArgumentException("Duplicate gold balance.");
            var entry=entries.FirstOrDefault();if(entry==null){entry=new Currency{Type=CurrencyType.Gold,Id="gold"};a.Currencies.Add(entry);}
            if(entry.Amount<0)throw new ArgumentException("Gold cannot be negative.");return entry;
        }
        public static long GetGold(CharacterData a)=>Gold(a).Amount;
        public static void AddGold(CharacterData a,long amount)
        {var c=Gold(a);long next=checked(c.Amount+amount);if(next<0)throw new ArgumentException("Not enough gold.");c.Amount=next;}
    }
    public sealed class ProgressionCatalog
    {
        public ProgressionDefinition Data {get;}
        public ProgressionCatalog(ProgressionDefinition data)
        {
            Data=data??throw new ArgumentNullException(nameof(data));
            if(data.SchemaVersion!=1||string.IsNullOrWhiteSpace(data.ConfigVersion)||data.MaxPlayerLevel<1||data.StaminaRecoverySeconds<1||data.InitialGold<0||data.InitialStamina<0)throw new ArgumentException("Invalid progression config.");
            if(data.PlayerLevels==null||data.HeroLevels==null||data.PlayerLevels.GroupBy(x=>x.Level).Any(x=>x.Count()!=1)||data.HeroLevels.GroupBy(x=>x.Level).Any(x=>x.Count()!=1))throw new ArgumentException("Duplicate progression levels.");
            for(int i=1;i<=data.MaxPlayerLevel;i++)
            {var row=Player(i);if(row.MaxHeroLevel<1||row.MaxStamina<1||row.StaminaReward<0||row.NextLevelExp<0||(i<data.MaxPlayerLevel&&row.NextLevelExp==0))throw new ArgumentException("Invalid player level: "+i);Hero(row.MaxHeroLevel);}
            int max=data.HeroLevels.Max(x=>x.Level);
            for(int i=1;i<=max;i++)if(Hero(i).NextLevelExp<0||(i<max&&Hero(i).NextLevelExp==0))throw new ArgumentException("Invalid hero level: "+i);
        }
        public PlayerLevelDefinition Player(int level)=>Data.PlayerLevels.SingleOrDefault(x=>x.Level==level)??throw new ArgumentException("Missing player level: "+level);
        public HeroLevelDefinition Hero(int level)=>Data.HeroLevels.SingleOrDefault(x=>x.Level==level)??throw new ArgumentException("Missing hero level: "+level);
        public long PlayerRequired(int level)=>level>=Data.MaxPlayerLevel?0:Player(level).NextLevelExp;
        public bool Initialize(CharacterData a,long now)
        {
            if(a.EconomyVersion>1)throw new ArgumentException("Unsupported economy save version.");
            if(a.Level<1||a.Level>Data.MaxPlayerLevel||a.Exp<0)throw new ArgumentException("Invalid player progress.");
            if(a.EconomyVersion==1){CurrencyBalance.Gold(a);if(a.Stamina<0||a.StaminaRecoveryTimestamp<0)throw new ArgumentException("Invalid stamina state.");return false;}
            // Old Hero progress is retained, including development levels above the account cap.
            a.Stamina=Data.InitialStamina;a.StaminaRecoveryTimestamp=now;
            bool hadGold=a.Currencies!=null&&a.Currencies.Any(c=>c.Type==CurrencyType.Gold&&(string.IsNullOrEmpty(c.Id)||c.Id=="gold"||c.Id=="money"));
            var gold=CurrencyBalance.Gold(a);if(!hadGold)gold.Amount=Data.InitialGold;
            a.EconomyVersion=1;return true;
        }
        public bool Recover(CharacterData a,long now)
        {
            int cap=Player(a.Level).MaxStamina;
            if(now<a.StaminaRecoveryTimestamp)return false;
            if(a.Stamina>=cap)return false;
            long ticks=(now-a.StaminaRecoveryTimestamp)/Data.StaminaRecoverySeconds;if(ticks==0)return false;
            long count=Math.Min(ticks,(long)cap-a.Stamina);a.Stamina+=(int)count;
            a.StaminaRecoveryTimestamp=a.Stamina>=cap?now:checked(a.StaminaRecoveryTimestamp+count*Data.StaminaRecoverySeconds);return true;
        }
        public void SpendStamina(CharacterData a,int amount,long now)
        {
            if(amount<0)throw new ArgumentException("Negative stamina expense.");Recover(a,now);
            if(a.Stamina<amount)throw new ArgumentException("Not enough stamina.");
            bool full=a.Stamina>=Player(a.Level).MaxStamina;a.Stamina-=amount;
            if(full&&a.Stamina<Player(a.Level).MaxStamina)a.StaminaRecoveryTimestamp=now;
        }
        public ExperienceChange AddPlayerExp(CharacterData a,long amount,long now)
        {
            if(amount<0)throw new ArgumentException("Negative experience reward.");
            var change=new ExperienceChange{BeforeLevel=a.Level,BeforeExp=a.Exp,BeforeRequired=PlayerRequired(a.Level),Granted=amount};
            Recover(a,now);a.Exp=checked(a.Exp+amount);
            while(a.Level<Data.MaxPlayerLevel&&a.Exp>=Player(a.Level).NextLevelExp)
            {
                var row=Player(a.Level);a.Exp-=row.NextLevelExp;
                bool full=a.Stamina>=row.MaxStamina;a.Stamina=checked(a.Stamina+row.StaminaReward);a.Level++;
                if(full||a.Stamina>=Player(a.Level).MaxStamina)a.StaminaRecoveryTimestamp=now;
            }
            if(a.Level>=Data.MaxPlayerLevel)a.Exp=0;
            change.AfterLevel=a.Level;change.AfterExp=a.Exp;change.AfterRequired=PlayerRequired(a.Level);return change;
        }
        public ExperienceChange AddHeroExp(CharacterData account,HeroData hero,long amount)
        {
            if(amount<0)throw new ArgumentException("Negative hero experience.");
            var change=new ExperienceChange{HeroId=hero.HeroInstanceId,BeforeLevel=hero.Level,BeforeExp=hero.Exp,BeforeRequired=Hero(hero.Level).NextLevelExp,Granted=amount};
            int cap=Player(account.Level).MaxHeroLevel;
            // Grandfather test profiles; applying the new cap must never downgrade existing Heroes.
            if(hero.Level>cap)change.Granted=0;
            else
            {
                hero.Exp=checked(hero.Exp+amount);
                while(hero.Level<cap&&Hero(hero.Level).NextLevelExp>0&&hero.Exp>=Hero(hero.Level).NextLevelExp)
                {hero.Exp-=Hero(hero.Level).NextLevelExp;hero.Level++;}
                if(hero.Level>=cap)hero.Exp=Math.Min(hero.Exp,Hero(hero.Level).NextLevelExp);
            }
            change.AfterLevel=hero.Level;change.AfterExp=hero.Exp;change.AfterRequired=Hero(hero.Level).NextLevelExp;return change;
        }
    }
    // Restore account economy and existing Hero objects in place if persistence fails.
    public sealed class EconomyCheckpoint
    {
        readonly CharacterData a;readonly int level,stamina,version;readonly long exp,time,revision;
        readonly List<Currency> currencies;readonly List<EconomyBattleReceipt> receipts;
        readonly List<Tuple<HeroData,int,long>> heroes;
        public EconomyCheckpoint(CharacterData account)
        {
            a=account;level=a.Level;exp=a.Exp;stamina=a.Stamina;time=a.StaminaRecoveryTimestamp;version=a.EconomyVersion;revision=a.Revision;
            currencies=a.Currencies?.Select(c=>new Currency{Id=c.Id,Type=c.Type,Amount=c.Amount}).ToList();
            receipts=a.CampaignRewards?.ToList();heroes=a.HeroDesk.Select(h=>Tuple.Create(h,h.Level,h.Exp)).ToList();
        }
        public void Restore()
        {a.Level=level;a.Exp=exp;a.Stamina=stamina;a.StaminaRecoveryTimestamp=time;a.EconomyVersion=version;a.Revision=revision;a.Currencies=currencies;a.CampaignRewards=receipts;foreach(var h in heroes){h.Item1.Level=h.Item2;h.Item1.Exp=h.Item3;}}
    }
}
