module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff24 = {}

function FancyAbyssbuff24.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info["Main Attrib"] == "STR" then
    buff.update = override(buff.update, FancyAbyssbuff24.buff_update)
  end
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff24.buff_update(basefunc, buff, dt)
  buff.dt = buff.dt and buff.dt + dt or dt
  local owner = buff.owner
  if buff.dt == dt then
    buff:setAttribute("AP", 0.8 * owner.attribs.AP)
    buff:setAttribute("APDP", 100)
    buff:setAttribute("DotDRatio", 150)
    owner:rebuild()
  end
end

function FancyAbyssbuff24.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff24.createBuff)
  return skill
end

return FancyAbyssbuff24.init_fieldSkill
