module("ed.battlehero", package.seeall)
local ed = ed
PeakArena04 = {}

function PeakArena04.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if owner.info.ID == 38 or owner.info.ID == 65 or owner.info.ID == 37 or owner.info.ID == 24 or owner.info.ID == 73 then
    buff:setAttribute("DotDRatio", 30)
  end
  buff.unremoveable = true
  return buff
end

function PeakArena04.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, PeakArena04.createBuff)
  return skill
end

return PeakArena04.init_fieldSkill
