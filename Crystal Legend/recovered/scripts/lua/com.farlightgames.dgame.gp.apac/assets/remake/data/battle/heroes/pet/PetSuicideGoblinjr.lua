module("ed.battlehero", package.seeall)
local ed = ed
PetSuicideGoblinjr = {}
PetSuicideGoblinjr.PetSuicideGoblinjr_startBuffID = 1349

function PetSuicideGoblinjr.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petsuicidegoblinjr_buffadded then
    local bid = PetSuicideGoblinjr.PetSuicideGoblinjr_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petsuicidegoblinjr_buffadded = true
  end
  local master = pet.owner
  if master.hp <= master.attribs.HP * 0.3 and not pet.petsuicidegoblinjr_skillpasv_casted then
    local skillpasv = pet.skills.PetSuicideGoblinjr_pasv
    if skillpasv then
      skillpasv:takeEffectAt(master.position, master)
      pet.petsuicidegoblinjr_skillpasv_casted = true
    end
  end
end

function PetSuicideGoblinjr.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petsuicidegoblinjr_buffadded = nil
  pet.petsuicidegoblinjr_skillpasv_casted = nil
end

function PetSuicideGoblinjr.init_hero(hero)
  hero.update = override(hero.update, PetSuicideGoblinjr.hero_update)
  hero.reset = override(hero.reset, PetSuicideGoblinjr.hero_reset)
  return hero
end

return PetSuicideGoblinjr.init_hero
