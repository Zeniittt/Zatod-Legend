module("ed.battlehero", package.seeall)
local ed = ed
PeakArena09 = {}

function PeakArena09.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if owner.info.ID == 38 or owner.info.ID == 65 or owner.info.ID == 37 or owner.info.ID == 91 or owner.info.ID == 58 then
    buff:setAttribute("DotDRatio", 25)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena09.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena09.createBuff)
  return skill
end

return PeakArena09.init_fieldSkill
