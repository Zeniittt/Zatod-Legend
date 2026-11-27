module("ed.battlehero", package.seeall)
local ed = ed
GuildMountControlCD = {}

function GuildMountControlCD.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  owner.GuildMountControlcd = 0
  buff.update = override(buff.update, GuildMountControlCD.Buff_update)
  buff.unremoveable = true
  return buff
end

function GuildMountControlCD.Buff_update(basefunc, buff, dt)
  local owner = buff.owner
  owner.GuildMountControlcd = owner.GuildMountControlcd - dt
end

function GuildMountControlCD.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountControlCD.createBuff)
  return skill
end

return GuildMountControlCD.init_fieldSkill
