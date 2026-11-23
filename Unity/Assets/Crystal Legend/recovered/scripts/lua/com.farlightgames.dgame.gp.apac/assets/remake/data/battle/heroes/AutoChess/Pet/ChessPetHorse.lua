module("ed.battlehero", package.seeall)
local ed = ed
ChessPetHorse = {}
ChessPetHorse.PetHorse_startBuffID = 1349

function ChessPetHorse.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.pethorse_buffadded then
    local bid = ChessPetHorse.PetHorse_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.pethorse_buffadded = true
  end
  if not pet.petHorse_firsttick then
    pet.petHorse_firsttick = ed.engine.ticks
  end
  local master = pet.owner
  if ed.engine.ticks - pet.petHorse_firsttick > 8 and not pet.petHorse_skillpasv_casted then
    local skillpasv = pet.skills.PetHorse_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petHorse_skillpasv_casted = true
    end
  end
end

function ChessPetHorse.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.pethorse_buffadded = nil
  pet.pethorse_skillpasv_casted = nil
  pet.pethorse_skillatk1_started = nil
  pet.pethorse_skillatk1_countdown = nil
  pet.pethorse_skillatk1_casted = nil
  pet.pethorse_skillatk1_invisible = nil
end

function ChessPetHorse.init_hero(hero)
  hero.update = override(hero.update, ChessPetHorse.hero_update)
  hero.reset = override(hero.reset, ChessPetHorse.hero_reset)
  return hero
end

return ChessPetHorse.init_hero
