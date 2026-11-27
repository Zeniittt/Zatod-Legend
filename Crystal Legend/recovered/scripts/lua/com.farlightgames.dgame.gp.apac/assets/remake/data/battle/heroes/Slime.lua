module("ed.slime", package.seeall)
local ed = ed
Slime = {}

function Slime.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  local hp_regen = hero.attribs.HPR
  local hprbuffcaster
  if hp_regen and hp_regen < 0 then
    for i, tbuff in ipairs(hero.buff_list) do
      if tbuff.info.HPR and 0 > tbuff.info.HPR then
        hprbuffcaster = tbuff.caster
        break
      end
    end
    if hero.hp == 1 then
      hero.notPopupBattleInfo = true
      hero:takeDamage(1, "Holy", "hp", hprbuffcaster, nil, 0, true)
      hero.notPopupBattleInfo = false
    end
  end
end

function Slime.hero_getLostHPAfterImmunity(basefunc, self, damage, immunity, damage_type, source)
  local dmg, bCrit = basefunc(self, damage, immunity, damage_type, source)
  if damage_type == "AD" or not "AP" then
  end
  if 0 < dmg then
    dmg = dmg * 0.4
    return dmg, bCrit
  end
  return dmg, bCrit
end

function Slime.hero_reset(basefunc, hero)
  basefunc(hero)
end

function Slime.init_hero(hero)
  hero.update = override(hero.update, Slime.hero_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, Slime.hero_getLostHPAfterImmunity)
  hero.reset = override(hero.reset, Slime.hero_reset)
  return hero
end

return Slime.init_hero
