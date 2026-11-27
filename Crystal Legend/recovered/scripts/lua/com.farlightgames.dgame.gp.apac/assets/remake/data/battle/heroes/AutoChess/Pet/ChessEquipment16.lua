module("ed.battlehero", package.seeall)
local ed = ed
ChessEquipment16 = {}
ChessEquipment16.startBuffID = 1349

function ChessEquipment16.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.start_buffadded then
    local bid = ChessEquipment16.startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.start_buffadded = true
  end
  if not pet.ChessEquipment16_firsttick then
    pet.ChessEquipment16_firsttick = ed.engine.ticks
  end
  local master = pet.owner
  if ed.engine.ticks - pet.ChessEquipment16_firsttick > 8 and not pet.Equipment16_skillpasv_casted then
    local skillpasv = pet.skills.equipment16
    master:addBuff(skillpasv:createBuff(master), master)
    pet.Equipment16_skillpasv_casted = true
  end
end

function ChessEquipment16.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.start_buffadded = nil
  pet.Equipment16_skillpasv_casted = nil
end

function ChessEquipment16.init_hero(hero)
  hero.update = override(hero.update, ChessEquipment16.hero_update)
  hero.reset = override(hero.reset, ChessEquipment16.hero_reset)
  return hero
end

return ChessEquipment16.init_hero
