module("ed.battlehero", package.seeall)
local ed = ed
SoloCM = {}

function SoloCM.hero_true_init(hero)
  return hero
end

function SoloCM.init_hero(hero)
  SoloCM.hero_true_init(hero)
  return hero
end

return SoloCM.init_hero
