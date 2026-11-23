module("ed.battlehero", package.seeall)
local ed = ed
PetWaterElement = {}
PetWaterElement.PetWaterElement_startBuffID = 1349

function PetWaterElement.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petwaterelement_buffadded then
    local bid = PetWaterElement.PetWaterElement_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petwaterelement_buffadded = true
  end
  local master = pet.owner
  if not pet.petwaterelement_firsttick then
    pet.petwaterelement_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petwaterelement_firsttick > 80 and not pet.petwaterelement_skillpasv_casted then
    local skillpasv = pet.skills.PetWaterElement_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petwaterelement_skillpasv_casted = true
    end
  end
end

function PetWaterElement.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petwaterelement_buffadded = nil
  pet.petwaterelement_skillpasv_casted = nil
  pet.petwaterelement_firsttick = nil
end

function PetWaterElement.init_hero(hero)
  hero.update = override(hero.update, PetWaterElement.hero_update)
  hero.reset = override(hero.reset, PetWaterElement.hero_reset)
  return hero
end

return PetWaterElement.init_hero
