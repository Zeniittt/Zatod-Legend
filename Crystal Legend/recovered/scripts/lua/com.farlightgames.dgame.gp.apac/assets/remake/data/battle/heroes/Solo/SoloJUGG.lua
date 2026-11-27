module("ed.battlehero", package.seeall)
local ed = ed
SoloJUGG = {}
SoloJUGG.JUGG_ult_buffID = 6079

function SoloJUGG.skillult_start(basefunc, skill, target)
  basefunc(skill, target)
end

function SoloJUGG.skillult_onAttackFrame(basefunc, skill)
  basefunc(skill)
end

function SoloJUGG.skillult_finish(basefunc, skill)
  basefunc(skill)
end

function SoloJUGG.hero_true_init(hero)
  local skillult = hero.skills.JUGG_ult
  if skillult then
  end
  return hero
end

function SoloJUGG.init_hero(hero)
  SoloJUGG.hero_true_init(hero)
  return hero
end

return SoloJUGG.init_hero
