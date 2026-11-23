module("ed.battlehero", package.seeall)
local ed = ed
PetSkeletonWarrior = {}
PetSkeletonWarrior.PetSkeletonWarrior_startBuffID = 1349

function PetSkeletonWarrior.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petskeletonwarrior_buffadded then
    local bid = PetSkeletonWarrior.PetSkeletonWarrior_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petskeletonwarrior_buffadded = true
  end
  local master = pet.owner
  if not pet.petskeletonwarrior_skillpasv_casted then
    local skillpasv = pet.skills.PetSkeletonWarrior_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petskeletonwarrior_skillpasv_casted = true
    end
  end
end

function PetSkeletonWarrior.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petskeletonwarrior_buffadded = nil
  pet.petskeletonwarrior_skillpasv_casted = nil
end

function PetSkeletonWarrior.init_hero(hero)
  hero.update = override(hero.update, PetSkeletonWarrior.hero_update)
  hero.reset = override(hero.reset, PetSkeletonWarrior.hero_reset)
  return hero
end

return PetSkeletonWarrior.init_hero
