module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff33_2 = {}

function FancyAbyssbuff33_2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, FancyAbyssbuff33_2.Buff_update)
  if owner.info["Main Attrib"] == "INT" then
    buff:setAttribute("AP", owner.attribs.AP * 0.25)
  end
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff33_2.Buff_update(basefunc, buff, dt)
end

function FancyAbyssbuff33_2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff33_2.createBuff)
  return skill
end

return FancyAbyssbuff33_2.init_fieldSkill
