module("ed.battlehero", package.seeall)
local ed = ed
breakfast = {}

function breakfast.buff_update(basefunc, buff, dt)
  local owner = buff.owner
  if (owner.info.ID == 14 or owner.info.ID == 10012) and not owner.buff_if then
    owner:setMP(owner.mp + 500)
  end
  owner.buff_if = true
  basefunc(buff, dt)
end

function breakfast.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, breakfast.buff_update)
  return buff
end

function breakfast.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, breakfast.createBuff)
  return skill
end

return breakfast.init_fieldSkill
