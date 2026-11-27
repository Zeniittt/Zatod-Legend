module("ed.battlehero", package.seeall)
local ed = ed
FancyAbyssbuff20 = {}

function FancyAbyssbuff20.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  local owner = buff.owner
  local caster = buff.caster
  buff.update = override(buff.update, FancyAbyssbuff20.Buff_update)
  owner.fancy20 = true
  buff.unremoveable = true
  return buff
end

function FancyAbyssbuff20.Buff_update(basefunc, buff, dt)
end

function FancyAbyssbuff20.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, FancyAbyssbuff20.createBuff)
  return skill
end

return FancyAbyssbuff20.init_fieldSkill
