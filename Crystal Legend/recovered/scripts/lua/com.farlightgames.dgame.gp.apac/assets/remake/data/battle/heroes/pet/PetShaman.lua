module("ed.battlehero", package.seeall)
local ed = ed
PetShaman = {}
PetShaman.PetShaman_startBuffID = 1349

function PetShaman.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petshaman_buffadded then
    local bid = PetShaman.PetShaman_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petshaman_buffadded = true
  end
  local master = pet.owner
  if master.hp <= master.attribs.HP * 0.3 and not pet.petshaman_skillpasv_casted then
    local skillpasv = pet.skills.PetShaman_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petshaman_skillpasv_casted = true
    end
  end
end

function PetShaman.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petshaman_buffadded = nil
  pet.petshaman_skillpasv_casted = nil
end

function PetShaman.init_hero(hero)
  hero.update = override(hero.update, PetShaman.hero_update)
  hero.reset = override(hero.reset, PetShaman.hero_reset)
  return hero
end

return PetShaman.init_hero
