module("ed.battlehero", package.seeall)
local ed = ed
SoloNEC = {}

function SoloNEC.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local skillpasv = hero.skills.NEC_pasv
  if skillpasv then
    if not hero.HealTime then
      hero.HealTime = 0
    end
    if hero.HealTime then
      hero.HealTime = hero.HealTime + dt
      if hero.HealTime >= 1 then
        local HealPower = hero.attribs.HP * 0.01
        hero:takeHeal(HealPower, "hp", hero, nil, {
          type = 2,
          id = skillpasv.info.Slot
        })
        hero.HealTime = 0
      end
    end
  end
end

function SoloNEC.hero_true_init(hero)
  hero.update = override(hero.update, SoloNEC.hero_update)
  return hero
end

function SoloNEC.init_hero(hero)
  SoloNEC.hero_true_init(hero)
  return hero
end

return SoloNEC.init_hero
