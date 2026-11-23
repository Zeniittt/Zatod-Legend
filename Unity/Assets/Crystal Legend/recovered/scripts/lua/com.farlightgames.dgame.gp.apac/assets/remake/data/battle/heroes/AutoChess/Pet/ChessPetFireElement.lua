module("ed.battlehero", package.seeall)
local ed = ed
ChessPetFireElement = {}
ChessPetFireElement.PetFireElement_startBuffID = 1349

function ChessPetFireElement.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.petfireelement_buffadded then
    local bid = ChessPetFireElement.PetFireElement_startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.petfireelement_buffadded = true
  end
  local master = pet.owner
  if not pet.petfireelement_firsttick then
    pet.petfireelement_firsttick = ed.engine.ticks
  end
  if ed.engine.ticks - pet.petfireelement_firsttick > 8 and not pet.petfireelement_skillpasv_casted then
    local skillpasv = pet.skills.PetFireElement_pasv
    if skillpasv then
      master:addBuff(skillpasv:createBuff(master), master)
      pet.petfireelement_skillpasv_casted = true
    end
  end
end

function ChessPetFireElement.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.petfireelement_buffadded = nil
  pet.petfireelement_skillpasv_casted = nil
  pet.petfireelement_firsttick = nil
end

function ChessPetFireElement.init_hero(hero)
  hero.update = override(hero.update, ChessPetFireElement.hero_update)
  hero.reset = override(hero.reset, ChessPetFireElement.hero_reset)
  return hero
end

return ChessPetFireElement.init_hero
