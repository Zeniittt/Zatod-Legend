module("ed.battlehero", package.seeall)
local ed = ed
PetTreant = {}
PetTreant.PetTreant_startBuffID = 1349

function PetTreant.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.pettreant_buffadded then
    local bid = PetTreant.PetTreant_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.pettreant_buffadded = true
  end
  local master = pet.owner
  if not pet.pettreant_firsttick then
    pet.pettreant_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.pettreant_firsttick > 320 and not pet.pettreant_skillpasv_casted then
    local skillpasv = pet.skills.PetTreant_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.pettreant_skillpasv_casted = true
    end
  end
end

function PetTreant.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.pettreant_buffadded = nil
  pet.pettreant_skillpasv_casted = nil
  pet.pettreant_firsttick = nil
end

function PetTreant.init_hero(hero)
  hero.update = override(hero.update, PetTreant.hero_update)
  hero.reset = override(hero.reset, PetTreant.hero_reset)
  return hero
end

return PetTreant.init_hero
