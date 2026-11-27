module("ed.battlehero", package.seeall)
local ed = ed
PetGhoul = {}
PetGhoul.PetGhoul_startBuffID = 1349

function PetGhoul.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petghoul_buffadded then
    local bid = PetGhoul.PetGhoul_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petghoul_buffadded = true
  end
  local master = pet.owner
  if not pet.petghoul_firsttick then
    pet.petghoul_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petghoul_firsttick > 160 and not pet.petghoul_skillpasv_casted then
    local skillpasv = pet.skills.PetGhoul_pasv
    if skillpasv then
      skillpasv:takeEffectAt(master.position, master)
      pet.petghoul_skillpasv_casted = true
    end
  end
end

function PetGhoul.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petghoul_buffadded = nil
  pet.petghoul_skillpasv_casted = nil
  pet.petghoul_firsttick = nil
end

function PetGhoul.init_hero(hero)
  hero.update = override(hero.update, PetGhoul.hero_update)
  hero.reset = override(hero.reset, PetGhoul.hero_reset)
  return hero
end

return PetGhoul.init_hero
