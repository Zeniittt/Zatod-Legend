module("ed.battlehero", package.seeall)
local ed = ed
ChessPetCalf = {}
ChessPetCalf.PetCalf_startBuffID = 1349

function ChessPetCalf.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petcalf_buffadded then
    local bid = ChessPetCalf.PetCalf_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petcalf_buffadded = true
  end
  local master = pet.owner
  if master.hp <= master.attribs.HP * 0.5 and not pet.petcalf_skillpasv_casted then
    local skillpasv = pet.skills.PetCalf_pasv
    if skillpasv then
      skillpasv:takeEffectOn(master, master)
      pet.petcalf_skillpasv_casted = true
    end
  end
end

function ChessPetCalf.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petcalf_buffadded = nil
  pet.petcalf_skillpasv_casted = nil
  pet.petcalf_skillatk1_started = nil
  pet.petcalf_skillatk1_countdown = nil
  pet.petcalf_skillatk1_casted = nil
  pet.petcalf_skillatk1_invisible = nil
end

function ChessPetCalf.init_hero(hero)
  hero.update = override(hero.update, ChessPetCalf.hero_update)
  hero.reset = override(hero.reset, ChessPetCalf.hero_reset)
  return hero
end

return ChessPetCalf.init_hero
