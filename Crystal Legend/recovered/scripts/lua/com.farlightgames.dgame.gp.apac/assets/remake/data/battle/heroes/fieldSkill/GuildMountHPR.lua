module("ed.battlehero", package.seeall)
local ed = ed
GuildMountHPR = {}

function GuildMountHPR.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  owner.GuildMountHPR = true
  buff.update = override(buff.update, GuildMountHPR.Buff_update)
  local difficult = ed.getDataTable("GuildMountBoss")[ed.engine.guildMountBossId].Difficult
  local hpr = 0
  if difficult < 3 then
    hpr = -(150 + difficult * 20)
  end
  if 3 <= difficult then
    hpr = -(100 + difficult * 40)
  end
  buff:setAttribute("HPR", hpr)
  buff.unremoveable = true
  return buff
end

function GuildMountHPR.Buff_update(basefunc, buff, dt)
end

function GuildMountHPR.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, GuildMountHPR.createBuff)
  return skill
end

return GuildMountHPR.init_fieldSkill
