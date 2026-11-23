module("ed.battlehero", package.seeall)
local ed = ed
ChessPetChessSoldier = {}
ChessPetChessSoldier.PetChessSoldier_startBuffID = 1349

function ChessPetChessSoldier.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.PetChessSoldier_buffadded then
    local bid = ChessPetChessSoldier.PetChessSoldier_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetChessSoldier_buffadded = true
  end
  local master = pet.owner
  if not pet.petChessSoldier_firsttick then
    pet.petChessSoldier_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petChessSoldier_firsttick > 8 and not pet.PetChessSoldier_skillpasv_casted then
    local skillpasv = pet.skills.PetChessSoldier_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.PetChessSoldier_skillpasv_casted = true
    end
  end
end

function ChessPetChessSoldier.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetChessSoldier_buffadded = nil
  pet.PetChessSoldier_skillpasv_casted = nil
  pet.PetChessSoldier_skillatk1_started = nil
  pet.PetChessSoldier_skillatk1_countdown = nil
  pet.PetChessSoldier_skillatk1_casted = nil
  pet.PetChessSoldier_skillatk1_invisible = nil
end

function ChessPetChessSoldier.init_hero(hero)
  hero.update = override(hero.update, ChessPetChessSoldier.hero_update)
  hero.reset = override(hero.reset, ChessPetChessSoldier.hero_reset)
  return hero
end

return ChessPetChessSoldier.init_hero
