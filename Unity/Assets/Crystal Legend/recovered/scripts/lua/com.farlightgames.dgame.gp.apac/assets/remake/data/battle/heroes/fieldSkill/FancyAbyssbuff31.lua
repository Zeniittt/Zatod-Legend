module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff31 = {}

function FancyAbyssbuff31.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  if owner.info["Main Attrib"] == "INT" then
    buff:setAttribute("AP", owner.attribs.AP * 0.3)
    buff:setAttribute("DotDRatio", 300)
  end
  buff.update = override(buff.update, FancyAbyssbuff31.Buff_update)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff31.Buff_update(basefunc, buff, dt)
end

function FancyAbyssbuff31.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff31.createBuff)
  return skill
end

return FancyAbyssbuff31.init_fieldSkill
