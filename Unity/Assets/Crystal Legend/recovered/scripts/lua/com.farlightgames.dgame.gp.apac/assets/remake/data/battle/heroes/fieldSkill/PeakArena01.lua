module("ed.battlehero", package.seeall)
local ed = ed
PeakArena01 = {}

function PeakArena01.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if owner.info.ID == 8 or owner.info.ID == 50 or owner.info.ID == 60 or owner.info.ID == 42 or owner.info.ID == 17 then
    owner.peakarena01 = true
  end
  buff.update = override(buff.update, PeakArena01.Buff_update)
  buff.unremoveable = true
  return buff
end

function PeakArena01.Buff_update(basefunc, buff, dt)
end

function PeakArena01.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena01.createBuff)
  return skill
end

return PeakArena01.init_fieldSkill
