module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff29 = {}

function FancyAbyssbuff29.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  buff:setAttribute("AP", owner.attribs.AP * 0.3)
  buff.update = override(buff.update, FancyAbyssbuff29.Buff_update)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff29.Buff_update(basefunc, buff, dt)
end

function FancyAbyssbuff29.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff29.createBuff)
  return skill
end

return FancyAbyssbuff29.init_fieldSkill
