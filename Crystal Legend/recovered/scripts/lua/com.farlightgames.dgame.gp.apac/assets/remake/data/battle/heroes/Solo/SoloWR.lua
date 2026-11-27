module("ed.battlehero", package.seeall)
local ed = ed
SoloWR = {}

function SoloWR.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local WR_pasv = hero.skills.WR_pasv
  if hero.hp <= hero.attribs.HP * 0.5 and not hero.hero_skillpasv_casted and WR_pasv then
    hero:addBuff(WR_pasv:createBuff(hero), hero)
    hero.hero_skillpasv_casted = true
  end
end

function SoloWR.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.hero_skillpasv_casted = false
end

function SoloWR.hero_true_init(hero)
  hero.update = override(hero.update, SoloWR.hero_update)
  hero.reset = override(hero.reset, SoloWR.hero_reset)
  return hero
end

function SoloWR.init_hero(hero)
  SoloWR.hero_true_init(hero)
  return hero
end

return SoloWR.init_hero
