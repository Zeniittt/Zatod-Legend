module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff10_2 = {}

function FancyAbyssbuff10_2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff.unremoveable = true
  owner.fancy10atkcount = 0
  return buff
end

function FancyAbyssbuff10_2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff10_2.createBuff)
  return skill
end

return FancyAbyssbuff10_2.init_fieldSkill
