module("ed.Ghost", package.seeall)
local ed = ed
Ghost = {}

function Ghost.skillatk2_createBuff(basefunc, skill, target)
  local buff = basefunc(skill, target)
  buff:setAttribute("fearrange", 5)
  return buff
end

function Ghost.init_hero(hero)
  local skillatk2 = hero.skills.Ghost_atk2
  if skillatk2 then
    skillatk2.createBuff = override(skillatk2.createBuff, Ghost.skillatk2_createBuff)
  end
  return hero
end

return Ghost.init_hero
