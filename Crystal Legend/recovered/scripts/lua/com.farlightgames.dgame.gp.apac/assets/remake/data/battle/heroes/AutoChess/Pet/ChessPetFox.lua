module("ed.battlehero", package.seeall)
local ed = ed
ChessPetFox = {}
ChessPetFox.PetFox_startBuffID = 1349

function ChessPetFox.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petfox_buffadded then
    local bid = ChessPetFox.PetFox_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petfox_buffadded = true
  end
  if not pet.petFox_firsttick then
    pet.petFox_firsttick = ed.engine.ticks
  end
  local master = pet.owner
  if ed.engine.ticks - pet.petFox_firsttick > 8 and not pet.petFox_skillpasv_casted then
    local skillpasv = pet.skills.PetFox_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petFox_skillpasv_casted = true
    end
  end
end

function ChessPetFox.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petfox_buffadded = nil
  pet.petfox_skillpasv_casted = nil
  pet.petfox_skillatk1_started = nil
  pet.petfox_skillatk1_countdown = nil
  pet.petfox_skillatk1_casted = nil
  pet.petfox_skillatk1_invisible = nil
end

function ChessPetFox.init_hero(hero)
  hero.update = override(hero.update, ChessPetFox.hero_update)
  hero.reset = override(hero.reset, ChessPetFox.hero_reset)
  return hero
end

return ChessPetFox.init_hero
