module("ed.ThunderHide", package.seeall)
local ed = ed
ThunderHide = {}

function ThunderHide.skillatk2_power(basefunc, self, source, target, damage_type)
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

function ThunderHide.init_hero(hero)
  local skillatk2 = hero.skills.ThunderHide_atk2
  if skillatk2 then
    skillatk2.power = override(skillatk2.power, ThunderHide.skillatk2_power)
  end
  return hero
end

return ThunderHide.init_hero
