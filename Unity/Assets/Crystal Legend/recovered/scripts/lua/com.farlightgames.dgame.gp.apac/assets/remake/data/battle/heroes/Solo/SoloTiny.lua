module("ed.battlehero", package.seeall)
local ed = ed
SoloTiny = {}

function SoloTiny.hero_reset(basefunc, hero)
  basefunc(hero)
  local skillpasv = hero.skills.Tiny_pasv
  if skillpasv then
    skillpasv:takeEffectOn(hero)
  end
end

function SoloTiny.hero_true_init(hero)
  hero.reset = override(hero.reset, SoloTiny.hero_reset)
  return hero
end

function SoloTiny.init_hero(hero)
  SoloTiny.hero_true_init(hero)
  return hero
end

return SoloTiny.init_hero
