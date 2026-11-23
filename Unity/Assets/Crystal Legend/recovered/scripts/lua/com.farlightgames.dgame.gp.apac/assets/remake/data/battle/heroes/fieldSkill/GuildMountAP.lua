module("ed.battlehero", package.seeall)
local ed = ed
GuildMountAP = {}

function GuildMountAP.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, GuildMountAP.Buff_update)
  owner.GMCdifficult = ed.getDataTable("GuildMountBoss")[ed.engine.guildMountBossId].Difficult
  buff:setAttribute("APDP", 60 + 2 * owner.GMCdifficult)
  buff.unremoveable = true
  return buff
end

function GuildMountAP.Buff_update(basefunc, buff, dt)
end

function GuildMountAP.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountAP.createBuff)
  return skill
end

return GuildMountAP.init_fieldSkill
