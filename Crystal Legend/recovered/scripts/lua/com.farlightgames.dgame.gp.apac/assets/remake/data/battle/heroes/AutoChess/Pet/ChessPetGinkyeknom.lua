module("ed.battlehero", package.seeall)
local ed = ed
ChessPetGinkyeknom = {}
ChessPetGinkyeknom.PetGinkyeknom_startBuffID = 1349

function ChessPetGinkyeknom.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petGinkyeknom_buffadded then
    local bid = ChessPetGinkyeknom.PetGinkyeknom_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petGinkyeknom_buffadded = true
  end
  if not pet.petGinkyeknom_firsttick then
    pet.petGinkyeknom_firsttick = ed.engine.ticks
  end
  local master = pet.owner
  if ed.engine.ticks - pet.petGinkyeknom_firsttick > 8 and not pet.petGinkyeknom_skillpasv_casted then
    local skillpasv = pet.skills.PetGinkyeknom_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petGinkyeknom_skillpasv_casted = true
    end
  end
end

function ChessPetGinkyeknom.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petGinkyeknom_buffadded = nil
  pet.petGinkyeknom_skillpasv_casted = nil
  pet.petGinkyeknom_skillatk1_started = nil
  pet.petGinkyeknom_skillatk1_countdown = nil
  pet.petGinkyeknom_skillatk1_casted = nil
  pet.petGinkyeknom_skillatk1_invisible = nil
end

function ChessPetGinkyeknom.init_hero(hero)
  hero.update = override(hero.update, ChessPetGinkyeknom.hero_update)
  hero.reset = override(hero.reset, ChessPetGinkyeknom.hero_reset)
  return hero
end

return ChessPetGinkyeknom.init_hero
