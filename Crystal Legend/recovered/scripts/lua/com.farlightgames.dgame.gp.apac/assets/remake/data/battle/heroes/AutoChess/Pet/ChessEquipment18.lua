module("ed.battlehero", package.seeall)
local ed = ed
ChessEquipment18 = {}
ChessEquipment18.startBuffID = 1349

function ChessEquipment18.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.start_buffadded then
    local bid = ChessEquipment18.startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.start_buffadded = true
  end
  if not pet.ChessEquipment18_firsttick then
    pet.ChessEquipment18_firsttick = ed.engine.ticks
  end
  local master = pet.owner
  if ed.engine.ticks - pet.ChessEquipment18_firsttick > 8 and not pet.Equipment18_skillpasv_casted then
    local skillpasv = pet.skills.equipment18
    master:addBuff(skillpasv:createBuff(master), master)
    pet.Equipment18_skillpasv_casted = true
  end
end

function ChessEquipment18.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.start_buffadded = nil
  pet.Equipment18_skillpasv_casted = nil
end

function ChessEquipment18.init_hero(hero)
  hero.update = override(hero.update, ChessEquipment18.hero_update)
  hero.reset = override(hero.reset, ChessEquipment18.hero_reset)
  return hero
end

return ChessEquipment18.init_hero
