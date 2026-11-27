module("ed.battlehero", package.seeall)
local ed = ed
PeakArena05 = {}

function PeakArena05.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if owner.info.ID == 27 or owner.info.ID == 28 or owner.info.ID == 1 or owner.info.ID == 23 or owner.info.ID == 47 then
    buff:setAttribute("HAST", 30)
    buff:setAttribute("MSPD", 30)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena05.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena05.createBuff)
  return skill
end

return PeakArena05.init_fieldSkill
