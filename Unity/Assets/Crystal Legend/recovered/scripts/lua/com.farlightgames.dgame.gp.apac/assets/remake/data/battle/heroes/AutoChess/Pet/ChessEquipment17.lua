module("ed.battlehero", package.seeall)
local ed = ed
ChessEquipment17 = {}
ChessEquipment17.startBuffID = 1349

function ChessEquipment17.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.start_buffadded then
    local bid = ChessEquipment17.startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.start_buffadded = true
  end
  if not pet.ChessEquipment17_firsttick then
    pet.ChessEquipment17_firsttick = ed.engine.ticks
  end
  local master = pet.owner
  if ed.engine.ticks - pet.ChessEquipment17_firsttick > 8 and not pet.Equipment17_skillpasv_casted then
    local skillpasv = pet.skills.equipment17
    master:addBuff(skillpasv:createBuff(master), master)
    pet.Equipment17_skillpasv_casted = true
  end
end

function ChessEquipment17.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.start_buffadded = nil
  pet.Equipment17_skillpasv_casted = nil
end

function ChessEquipment17.init_hero(hero)
  hero.update = override(hero.update, ChessEquipment17.hero_update)
  hero.reset = override(hero.reset, ChessEquipment17.hero_reset)
  return hero
end

return ChessEquipment17.init_hero
