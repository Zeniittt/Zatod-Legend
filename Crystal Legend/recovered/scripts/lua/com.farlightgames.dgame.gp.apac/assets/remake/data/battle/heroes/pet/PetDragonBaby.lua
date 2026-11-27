module("ed.battlehero", package.seeall)
local ed = ed
PetDragonBaby = {}
PetDragonBaby.PetDragonBaby_startBuffID = 1349

function PetDragonBaby.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petdragonbaby_buffadded then
    local bid = PetDragonBaby.PetDragonBaby_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petdragonbaby_buffadded = true
  end
  local master = pet.owner
  if not pet.petdragonbaby_firsttick then
    pet.petdragonbaby_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petdragonbaby_firsttick > 240 and not pet.petdragonbaby_skillpasv_casted then
    local skillpasv = pet.skills.PetDragonBaby_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petdragonbaby_skillpasv_casted = true
    end
  end
end

function PetDragonBaby.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petdragonbaby_buffadded = nil
  pet.petdragonbaby_skillpasv_casted = nil
  pet.petdragonbaby_firsttick = nil
end

function PetDragonBaby.init_hero(hero)
  hero.update = override(hero.update, PetDragonBaby.hero_update)
  hero.reset = override(hero.reset, PetDragonBaby.hero_reset)
  return hero
end

return PetDragonBaby.init_hero
