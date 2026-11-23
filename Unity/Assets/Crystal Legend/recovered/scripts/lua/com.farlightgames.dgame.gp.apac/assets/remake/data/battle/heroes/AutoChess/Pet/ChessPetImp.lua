module("ed.battlehero", package.seeall)
local ed = ed
ChessPetImp = {}
ChessPetImp.PetImp_startBuffID = 1349

function ChessPetImp.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petImp_buffadded then
    local bid = ChessPetImp.PetImp_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petImp_buffadded = true
  end
  local master = pet.owner
  if not pet.petImp_firsttick then
    pet.petImp_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petImp_firsttick > 8 and not pet.petImp_skillpasv_casted then
    local skillpasv = pet.skills.PetImp_pasv
    if skillpasv then
      print("have pasv skill")
      master:addBuff(skillpasv:createBuff(master), master)
      print(master.name)
      pet.petImp_skillpasv_casted = true
    end
  end
end

function ChessPetImp.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petImp_buffadded = nil
  pet.petImp_skillpasv_casted = nil
  pet.petImp_firsttick = nil
  pet.petImp_skillatk1_countdown = nil
  pet.petImp_skillatk1_started = nil
  pet.petImp_skillatk1_casted = nil
  pet.petImp_skillatk1_invisible = nil
end

function ChessPetImp.init_hero(hero)
  hero.update = override(hero.update, ChessPetImp.hero_update)
  hero.reset = override(hero.reset, ChessPetImp.hero_reset)
  return hero
end

return ChessPetImp.init_hero
