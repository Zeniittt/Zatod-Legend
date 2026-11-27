module("ed.battlehero", package.seeall)
local ed = ed
GuildMountHast = {}

function GuildMountHast.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, GuildMountHast.Buff_update)
  owner.GMHast = true
  buff.unremoveable = true
  owner.GuildMountHastinitad = owner.attribs.AD
  owner.GuildMountHastinitap = owner.attribs.AP
  return buff
end

function GuildMountHast.Buff_update(basefunc, buff, dt)
  local owner = buff.owner
end

function GuildMountHast.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountHast.createBuff)
  return skill
end

return GuildMountHast.init_fieldSkill
