module("ed.battlehero", package.seeall)
local ed = ed
ChessPetCrow = {}
ChessPetCrow.PetCrow_startBuffID = 1349

function ChessPetCrow.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petcrow_buffadded then
    local bid = ChessPetCrow.PetCrow_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petcrow_buffadded = true
  end
  local master = pet.owner
  if master.hp <= master.attribs.HP * 0.5 and not pet.petcrow_skillpasv_casted then
    local skillpasv = pet.skills.PetCrow_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petcrow_skillpasv_casted = true
    end
  end
end

function ChessPetCrow.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petcrow_buffadded = nil
  pet.petcrow_skillpasv_casted = nil
  pet.petcrow_skillatk1_started = nil
  pet.petcrow_skillatk1_countdown = nil
  pet.petcrow_skillatk1_casted = nil
  pet.petcrow_skillatk1_invisible = nil
end

function ChessPetCrow.init_hero(hero)
  hero.update = override(hero.update, ChessPetCrow.hero_update)
  hero.reset = override(hero.reset, ChessPetCrow.hero_reset)
  return hero
end

return ChessPetCrow.init_hero
