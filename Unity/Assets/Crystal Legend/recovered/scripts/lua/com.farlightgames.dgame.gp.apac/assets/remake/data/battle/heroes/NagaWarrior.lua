module("ed.NagaWarrior", package.seeall)
local ed = ed
NagaWarrior = {}

function NagaWarrior.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.hasBuff == false then
    local bid = 10034601
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, hero)
    hero.hasBuff = true
  end
end

function NagaWarrior.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.hasBuff = false
  hero.dt = nil
end

function NagaWarrior.hero_getLostHPAfterImmunity(basefunc, self, damage, immunity, damage_type, source)
  local dmg = basefunc(self, damage, immunity, damage_type, source)
  local maxDmg = self.attribs.HP * 0.025
  if 0 < dmg then
    if dmg >= maxDmg then
      dmg = dmg - maxDmg
    else
      dmg = 0
    end
  end
  return dmg
end

function NagaWarrior.init_hero(hero)
  hero.reset = override(hero.reset, NagaWarrior.hero_reset)
  hero.update = override(hero.update, NagaWarrior.hero_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, NagaWarrior.hero_getLostHPAfterImmunity)
  return hero
end

return NagaWarrior.init_hero
