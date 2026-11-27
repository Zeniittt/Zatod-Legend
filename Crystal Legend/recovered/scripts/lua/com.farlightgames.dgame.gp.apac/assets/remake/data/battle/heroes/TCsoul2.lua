module("ed.battlehero", package.seeall)
local ed = ed
TCsoul2 = {}

function TCsoul2.skillatk_getDamage(basefunc, self, target, power, damage_type, field, source, crit_mod)
  local caster = self.caster
  power = power + caster.config.summoner.attribs.AP * 0.22
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

function TCsoul2.skillatk_takeEffectOn(basefunc, skill, target)
  local originfo = skill.info
  if skill.attack_counter == 9 then
    skill.info = ed.wraptable(originfo, {
      ["Knock Up"] = 0.45,
      ["Knock Back"] = 10,
      ["Plus Ratio"] = 4.5,
      ["Shape Arg1"] = 138
    })
  end
  basefunc(skill, target)
  skill.info = originfo
end

function TCsoul2.init_hero(hero)
  local skill_atk = hero.skills.TCsoul2_atk
  if skill_atk then
    skill_atk.getDamage = override(skill_atk.getDamage, TCsoul2.skillatk_getDamage)
    skill_atk.takeEffectOn = override(skill_atk.takeEffectOn, TCsoul2.skillatk_takeEffectOn)
  end
  return hero
end

return TCsoul2.init_hero
