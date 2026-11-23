module("ed.battlehero", package.seeall)
local ed = ed
PetDragonTurtle = {}
PetDragonTurtle.PetDragonTurtle_startBuffID = 1349

function PetDragonTurtle.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petdragonturtle_buffadded then
    local bid = PetDragonTurtle.PetDragonTurtle_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petdragonturtle_buffadded = true
  end
  local master = pet.owner
  if not pet.petdragonturtle_skillpasv_casted then
    local skillpasv = pet.skills.PetDragonTurtle_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petdragonturtle_skillpasv_casted = true
    end
  end
end

function PetDragonTurtle.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petdragonturtle_buffadded = nil
  pet.petdragonturtle_skillpasv_casted = nil
end

function PetDragonTurtle.init_hero(hero)
  hero.update = override(hero.update, PetDragonTurtle.hero_update)
  hero.reset = override(hero.reset, PetDragonTurtle.hero_reset)
  return hero
end

return PetDragonTurtle.init_hero
