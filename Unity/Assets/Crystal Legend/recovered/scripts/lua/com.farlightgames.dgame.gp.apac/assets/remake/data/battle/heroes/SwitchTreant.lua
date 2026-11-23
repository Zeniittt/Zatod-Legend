module("ed.battlehero", package.seeall)
local ed = ed
SwitchTreant = {}

function SwitchTreant.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function SwitchTreant.init_hero(hero)
  local skillatk2 = hero.skills.SwitchTreant_atk2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, SwitchTreant.skillatk2_createBuff)
  end
  return hero
end

return SwitchTreant.init_hero
