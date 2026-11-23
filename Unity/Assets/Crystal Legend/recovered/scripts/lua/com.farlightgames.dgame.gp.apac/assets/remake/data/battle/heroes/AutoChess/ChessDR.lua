module("ed.battlehero", package.seeall)
local ed = ed
ChessDR = {}

function ChessDR.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillult = hero.skills.DR_ult
  if skillult then
    skillult:takeEffectOn(hero)
  end
end

function ChessDR.init_hero(hero)
  hero.reset = override(hero.reset, ChessDR.hero_reset)
  return hero
end

return ChessDR.init_hero
