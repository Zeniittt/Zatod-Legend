module("ed.RuneTurtle", package.seeall)
local ed = ed
RuneTurtle = {}

function RuneTurtle.hero_getLostHPAfterImmunity(basefunc, self, damage, immunity, damage_type, source)
  local dmg, bCrit = basefunc(self, damage, immunity, damage_type, source)
  local maxDmg = self.attribs.HP * 0.05
  if dmg then
    if dmg > maxDmg then
      return maxDmg, bCrit
    else
      return dmg, bCrit
    end
  end
  return dmg, bCrit
end

function RuneTurtle.init_hero(hero)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, RuneTurtle.hero_getLostHPAfterImmunity)
  return hero
end

return RuneTurtle.init_hero
