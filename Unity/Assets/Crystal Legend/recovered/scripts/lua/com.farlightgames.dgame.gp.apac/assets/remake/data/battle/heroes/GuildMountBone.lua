module("ed.battlehero", package.seeall)
local ed = ed
GuildMountBone = {}

function GuildMountBone.skillatk2_takeEffectOn(basefunc, self, target, source, shift)
  local ret, dmg, Crit, lfs_amount = basefunc(self, target, source, shift)
  return ret, dmg, Crit, lfs_amount
end

function GuildMountBone.skillatk2_power(basefunc, self, source, target, damage_type)
  local power, i = basefunc(self, source, target, damage_type)
  return power, i
end

function GuildMountBone.skillatk3_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local buffInfo = buff.info
  local owner = buff.owner
  local caster = buff.caster
  local hast = buffInfo.HAST
  return buff
end

function GuildMountBone.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
  local caster = skill.caster
end

function GuildMountBone.skillult_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local caster = skill.caster
  local AD = buff.info.AD
  return buff
end

function GuildMountBone.init_hero(hero)
  local skillult = hero.skills.GuildMountBone_ult
  local skillatk2 = hero.skills.GuildMountBone_atk2
  local skillatk3 = hero.skills.GuildMountBone_atk3
  local skillpasv = hero.passive_skill_list[1]
  return hero
end

return GuildMountBone.init_hero
