module("ed.battlehero", package.seeall)
local ed = ed
GuildMountAPUlt = {}

function GuildMountAPUlt.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.onDamaged = override(buff.onDamaged, GuildMountAPUlt.Buff_onDamaged)
  return buff
end

function GuildMountAPUlt.Buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local dmg = basefunc(buff, damage, damage_type, source, skill, transferred, field, bCrit, damageinfo, amount)
  local skilldinault = source.skills.tornado_atk2
  if skill and skill.info.Slot and (skill.info.Slot == 1 or skill == skilldinault) and damage_type == "AP" then
    dmg = dmg * 2
  end
  return dmg
end

function GuildMountAPUlt.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountAPUlt.createBuff)
  return skill
end

return GuildMountAPUlt.init_fieldSkill
