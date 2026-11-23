module("ed.battlehero", package.seeall)
local ed = ed
crazyUltimate2 = {}

function crazyUltimate2.buff_update(basefunc, buff, dt)
  local owner = buff.owner
  local mp = owner.mp
  owner:setMP(mp + 8)
  basefunc(buff, dt)
end

function crazyUltimate2.createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff.update = override(buff.update, crazyUltimate2.buff_update)
  return buff
end

function crazyUltimate2.init_fieldSkill(skill)
  skill.createBuff = override(skill.createBuff, crazyUltimate2.createBuff)
  return skill
end

return crazyUltimate2.init_fieldSkill
