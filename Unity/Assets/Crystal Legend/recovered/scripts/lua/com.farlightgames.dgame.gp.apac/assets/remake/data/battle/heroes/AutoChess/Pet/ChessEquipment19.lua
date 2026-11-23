module("ed.battlehero", package.seeall)
local ed = ed
ChessEquipment19 = {}
ChessEquipment19.startBuffID = 1349

function ChessEquipment19.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.start_buffadded then
    local bid = ChessEquipment19.startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.start_buffadded = true
  end
  if not pet.ChessEquipment19_firsttick then
    pet.ChessEquipment19_firsttick = ed.engine.ticks
  end
  local master = pet.owner
  if ed.engine.ticks - pet.ChessEquipment19_firsttick > 8 and not pet.Equipment19_skillpasv_casted then
    local skillpasv = pet.skills.equipment19
    master:addBuff(skillpasv:createBuff(master), master)
    pet.Equipment19_skillpasv_casted = true
  end
end

function ChessEquipment19.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.start_buffadded = nil
  pet.Equipment19_skillpasv_casted = nil
end

function ChessEquipment19.init_hero(hero)
  hero.update = override(hero.update, ChessEquipment19.hero_update)
  hero.reset = override(hero.reset, ChessEquipment19.hero_reset)
  return hero
end

return ChessEquipment19.init_hero
