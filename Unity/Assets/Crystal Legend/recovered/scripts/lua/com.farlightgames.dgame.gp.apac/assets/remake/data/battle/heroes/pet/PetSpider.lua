module("ed.battlehero", package.seeall)
local ed = ed
PetSpider = {}
PetSpider.PetSpider_startBuffID = 1349

function PetSpider.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petspider_buffadded then
    local bid = PetSpider.PetSpider_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petspider_buffadded = true
  end
  local master = pet.owner
  if not pet.petspider_firsttick then
    pet.petspider_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petspider_firsttick > 80 and not pet.petspider_skillpasv_casted then
    local skillpasv = pet.skills.PetSpider_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petspider_skillpasv_casted = true
    end
  end
end

function PetSpider.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petspider_buffadded = nil
  pet.petspider_skillpasv_casted = nil
end

function PetSpider.init_hero(hero)
  hero.update = override(hero.update, PetSpider.hero_update)
  hero.reset = override(hero.reset, PetSpider.hero_reset)
  return hero
end

return PetSpider.init_hero
