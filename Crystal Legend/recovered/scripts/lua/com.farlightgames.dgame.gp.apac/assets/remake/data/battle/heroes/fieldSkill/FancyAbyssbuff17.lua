module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff17 = {}

function FancyAbyssbuff17.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  if owner.info["Main Attrib"] == "INT" then
    buff:setAttribute("APDP", 60)
  end
  owner.fancybuff17 = true
  buff.update = override(buff.update, FancyAbyssbuff17.Buff_update)
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff17.Buff_update(basefunc, buff, dt)
end

function FancyAbyssbuff17.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff17.createBuff)
  return skill
end

return FancyAbyssbuff17.init_fieldSkill
