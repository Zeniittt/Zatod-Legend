local BattleResultConfig = {}
ed.BattleResultConfig = BattleResultConfig
local rh = ed.readhero
BattleResultConfig.GuildConfig = {
  HeroStars = {
    res = "UI/alpha/1080P/battleresult/fail_star .png",
    handler = rh.canHeroEvolve
  },
  UnitRank = {
    res = "UI/alpha/1080P/battleresult/fail_rank.png",
    handler = rh.canUpgradeHero
  },
  Equip = {
    res = "UI/alpha/1080P/battleresult/fail_equip .png",
    handler = rh.canHeroWearEquip
  },
  LevelUp = {
    res = "UI/alpha/1080P/battleresult/fail_levelup .png",
    handler = function()
      return true
    end
  },
  ["Skill Levelup"] = {
    res = "UI/alpha/1080P/battleresult/fail_skill .png",
    handler = rh.canHeroSkillLevelup
  },
  Rent = {
    res = "UI/alpha/1080P/battleresult/fail_employ .png",
    handler = function()
      return true
    end
  },
  Manipulate = {
    res = "UI/alpha/1080P/battleresult/fail_manual .png",
    handler = function()
      return true
    end
  },
  ["Battle Array"] = {
    res = "UI/alpha/1080P/battleresult/fail_exchange_lineup .png",
    handler = function()
      return #ed.player.heroes >= 10
    end
  }
}
