module("ed.battlehero", package.seeall)
local ed = ed
AwakeBossBone = {}

function AwakeBossBone.skillatk2_takeEffectOn(basefunc, self, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(self, target, source, shift)
  return ret, dmg, Crit, lfs_amount
end

function AwakeBossBone.skillatk2_power(basefunc, self, source, target, damage_type)
  local power, i = basefunc(self, source, target, damage_type)
  return power, i
end

function AwakeBossBone.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local hast = buffInfo.HAST
  return buff
end

function AwakeBossBone.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
end

function AwakeBossBone.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local AD = buff.info.AD
  return buff
end

function AwakeBossBone.init_hero(hero)
  local skillult = hero.skills.AwakeBossBone_ult
  local skillatk2 = hero.skills.AwakeBossBone_atk2
  local skillatk3 = hero.skills.AwakeBossBone_atk3
  local skillpasv = hero.passive_skill_list[1]
  return hero
end

return AwakeBossBone.init_hero
