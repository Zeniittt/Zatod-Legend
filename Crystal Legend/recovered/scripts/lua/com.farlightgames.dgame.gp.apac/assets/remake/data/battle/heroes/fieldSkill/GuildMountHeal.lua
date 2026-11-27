module("ed.battlehero", package.seeall)
local ed = ed
GuildMountHeal = {}

function GuildMountHeal.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  owner.GuildMountHeal = true
  buff.update = override(buff.update, GuildMountHeal.Buff_update)
  buff.unremoveable = true
  return buff
end

function GuildMountHeal.Buff_update(basefunc, buff, dt)
end

function GuildMountHeal.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountHeal.createBuff)
  return skill
end

return GuildMountHeal.init_fieldSkill
