module("ed.battlehero", package.seeall)
local ed = ed
ChessPetPig = {}
ChessPetPig.PetPig_startBuffID = 1349

function ChessPetPig.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  local master = pet.owner
  if not pet.PetPig_buffadded then
    local bid = ChessPetPig.PetPig_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetPig_buffadded = true
  end
  if not pet.PetPig_firsttick then
    pet.PetPig_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.PetPig_firsttick > 8 and not pet.PetPig_skillpasv_casted then
    local skillpasv = pet.skills.PetPig_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.PetPig_skillpasv_casted = true
    end
  end
end

function ChessPetPig.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetPig_buffadded = nil
  pet.PetPig_skillpasv_casted = nil
  pet.PetPig_firsttick = nil
  pet.PetPig_skillatk1_countdown = nil
  pet.PetPig_skillatk1_started = nil
  pet.PetPig_skillatk1_casted = nil
  pet.PetPig_skillatk1_invisible = nil
end

function ChessPetPig.init_hero(hero)
  hero.update = override(hero.update, ChessPetPig.hero_update)
  hero.reset = override(hero.reset, ChessPetPig.hero_reset)
  return hero
end

return ChessPetPig.init_hero
