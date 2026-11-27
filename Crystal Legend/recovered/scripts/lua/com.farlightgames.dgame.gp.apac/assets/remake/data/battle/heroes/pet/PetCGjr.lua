module("ed.battlehero", package.seeall)
local ed = ed
PetCGjr = {}
PetCGjr.PetCGjr_startBuffID = 1349

function PetCGjr.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petcgjr_buffadded then
    local bid = PetCGjr.PetCGjr_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petcgjr_buffadded = true
  end
  local master = pet.owner
  if master.hp <= master.attribs.HP * 0.2 and not pet.petcgjr_skillpasv_casted then
    local skillpasv = pet.skills.PetCGjr_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petcgjr_skillpasv_casted = true
    end
  end
end

function PetCGjr.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petcgjr_buffadded = nil
  pet.petcgjr_skillpasv_casted = nil
end

function PetCGjr.init_hero(hero)
  hero.update = override(hero.update, PetCGjr.hero_update)
  hero.reset = override(hero.reset, PetCGjr.hero_reset)
  return hero
end

return PetCGjr.init_hero
