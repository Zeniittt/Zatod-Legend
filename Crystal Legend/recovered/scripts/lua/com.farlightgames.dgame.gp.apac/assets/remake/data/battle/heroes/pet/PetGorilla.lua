module("ed.battlehero", package.seeall)
local ed = ed
PetGorilla = {}
PetGorilla.PetGorilla_startBuffID = 1349

function PetGorilla.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petgorilla_buffadded then
    local bid = PetGorilla.PetGorilla_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petgorilla_buffadded = true
  end
  local master = pet.owner
  if master.hp <= master.attribs.HP * 0.3 and not pet.petgorilla_skillpasv_casted then
    local skillpasv = pet.skills.PetGorilla_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petgorilla_skillpasv_casted = true
    end
  end
end

function PetGorilla.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petgorilla_buffadded = nil
  pet.petgorilla_skillpasv_casted = nil
end

function PetGorilla.init_hero(hero)
  hero.update = override(hero.update, PetGorilla.hero_update)
  hero.reset = override(hero.reset, PetGorilla.hero_reset)
  return hero
end

return PetGorilla.init_hero
