module("ed.battlehero", package.seeall)
local ed = ed
PetTauren = {}
PetTauren.PetTauren_startBuffID = 1349

function PetTauren.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.PetTauren_buffadded then
    local bid = PetTauren.PetTauren_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.PetTauren_buffadded = true
  end
  local master = pet.owner
  if master.hp <= master.attribs.HP * 0.3 and not pet.PetTauren_skillpasv_casted then
    local skillpasv = pet.skills.PetTauren_pasv
    if skillpasv then
      local newTarget = skillpasv:selectTarget(nil)
      if newTarget then
        pet:castSkill(skillpasv, newTarget)
      end
      pet.PetTauren_skillpasv_casted = true
    end
  end
end

function PetTauren.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.PetTauren_buffadded = nil
  pet.PetTauren_skillpasv_casted = nil
end

function PetTauren.init_hero(hero)
  hero.update = override(hero.update, PetTauren.hero_update)
  hero.reset = override(hero.reset, PetTauren.hero_reset)
  return hero
end

return PetTauren.init_hero
