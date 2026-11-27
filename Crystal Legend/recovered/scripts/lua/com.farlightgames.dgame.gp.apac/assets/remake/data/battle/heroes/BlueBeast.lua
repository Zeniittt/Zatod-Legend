module("ed.BlueBeast", package.seeall)
local ed = ed
BlueBeast = {}

function BlueBeast.skillatk2_power(basefunc, self, source, target, damage_type)
  local power, i = basefunc(self, source, target, damage_type)
  if target and target:isAlive() then
    local target_hsaShield = false
    for i, tbuff in ipairs(target.buff_list) do
      if tbuff.shield and tbuff.shield > 0 then
        target_hsaShield = true
        break
      end
    end
    if target_hsaShield then
      return power * 2, i
    end
  end
  return power, i
end

function BlueBeast.init_hero(hero)
  local skillatk2 = hero.skills.BlueBeast_atk2
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, BlueBeast.skillatk2_power)
  end
  return hero
end

return BlueBeast.init_hero
