module("ed.NagaMagicWarrior", package.seeall)
local ed = ed
NagaMagicWarrior = {}

function NagaMagicWarrior.hero_update(basefunc, hero, dt)
  basefunc(hero, dt)
  if hero.hasBuff == false then
    local bid = 10034601
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff = hero:addBuff(binfo, hero)
    hero.hasBuff = true
  end
end

function NagaMagicWarrior.hero_reset(basefunc, hero)
  basefunc(hero)
  hero.hasBuff = false
  hero.dt = nil
end

function NagaMagicWarrior.hero_getLostHPAfterImmunity(basefunc, self, damage, immunity, damage_type, source)
  local dmg, bCrit = basefunc(self, damage, immunity, damage_type, source)
  local maxDmg = self.attribs.HP * 0.1
  if dmg then
    if dmg >= maxDmg then
      dmg = dmg - maxDmg
    else
      dmg = 0
    end
  end
  return dmg, bCrit
end

function NagaMagicWarrior.init_hero(hero)
  hero.reset = override(hero.reset, NagaMagicWarrior.hero_reset)
  hero.update = override(hero.update, NagaMagicWarrior.hero_update)
  hero.getLostHPAfterImmunity = override(hero.getLostHPAfterImmunity, NagaMagicWarrior.hero_getLostHPAfterImmunity)
  return hero
end

return NagaMagicWarrior.init_hero
