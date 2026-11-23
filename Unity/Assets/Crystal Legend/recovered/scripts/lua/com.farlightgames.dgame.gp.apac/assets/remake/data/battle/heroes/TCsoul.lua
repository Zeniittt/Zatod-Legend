module("ed.battlehero", package.seeall)
local ed = ed
TCsoul = {}

function TCsoul.skillatk_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local caster = self.caster
  local skillatk2 = caster.config.summoner.skills.TC_atk2
  local ratio1 = skillatk2.info["Script Arg3"]
  local ratio2 = skillatk2.info["Script Arg4"]
  if skillatk2.evo_rank and skillatk2.evo_rank >= 1 then
    ratio1 = skillatk2.evo_rank1["Script Arg1"]
  end
  if skillatk2.evo_rank and skillatk2.evo_rank >= 2 then
    ratio2 = skillatk2.evo_rank2["Script Arg1"]
  end
  if self.attack_counter == 9 then
    power = skillatk2.info["Script Arg2"] + caster.config.summoner.attribs.AP * ratio2
  else
    power = skillatk2.info["Basic Num"] + caster.config.summoner.attribs.AP * ratio1
  end
  local dmg = target:takeDamage({
    amount = power,
    damage_type = damage_type,
    field = field,
    source = source,
    crit_mod = crit_mod,
    skill = self
  })
  return dmg
end

function TCsoul.skillatk_takeEffectOn(basefunc, skill, target, source, shift)
  local originfo = skill.info
  if skill.attack_counter == 9 then
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 0.45,
      ["Knock Back"] = 10,
      ["Shape Arg1"] = 138
    })
  end
  local caster = skill.caster
  local skillatk2 = caster.config.summoner.skills.TC_atk2
  local isHit, dmg, Crit, lfs_amount = basefunc(skill, target, source, shift)
  if isHit and skillatk2.evo_rank and skillatk2.evo_rank >= 3 then
    caster.config.summoner:takeHeal(caster.config.summoner.attribs.HP * skillatk2.evo_rank3["Script Arg1"] / 100, "hp")
  end
  skill.info = originfo
  return isHit, dmg, Crit, lfs_amount
end

function TCsoul.skillatk_finish(basefunc, skill)
  basefunc(skill)
  local caster = skill.caster
  if not caster.tcsoulatkcount then
    caster.tcsoulatkcount = 1
  else
    caster.tcsoulatkcount = caster.tcsoulatkcount + 1
  end
  if caster.tcsoulatkcount and caster.tcsoulatkcount >= 2 then
    skill.cd_remaining = 999
  end
end

function TCsoul.init_hero(hero)
  local skill_atk = hero.skills.TCsoul_atk
  if skill_atk then
    skill_atk.getDamage = override(skill_atk.getDamage, TCsoul.skillatk_getDamage)
    skill_atk.takeEffectOn = override(skill_atk.takeEffectOn, TCsoul.skillatk_takeEffectOn)
    skill_atk.finish = override(skill_atk.finish, TCsoul.skillatk_finish)
  end
  return hero
end

return TCsoul.init_hero
