module("ed.battlehero", package.seeall)
local ed = ed
ChessEquipment15 = {}
ChessEquipment15.startBuffID = 1349

function ChessEquipment15.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.start_buffadded then
    local bid = ChessEquipment15.startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.start_buffadded = true
  end
  if not pet.ChessEquipment15_firsttick then
    pet.ChessEquipment15_firsttick = ed.engine.ticks
  end
  local master = pet.owner
  if ed.engine.ticks - pet.ChessEquipment15_firsttick > 8 and not pet.Equipment15_skillpasv_casted then
    local skillpasv = pet.skills.equipment15
    local buff = master:addBuff(skillpasv:createBuff(master), pet)
    buff.onDamaged = override(buff.onDamaged, ChessEquipment15.Equipment15_buff_onDamaged)
    pet.Equipment15_skillpasv_casted = true
  end
end

function ChessEquipment15.Equipment15_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred)
  local damage = basefunc(buff, damage, damage_type, source, skill, transferred)
  if damage and 0 < damage then
    local rand = ed.rand()
    if rand < 0.35 then
      damage = damage * 0.65
    end
  end
  return damage
end

function ChessEquipment15.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.start_buffadded = nil
  pet.Equipment15_skillpasv_casted = nil
end

function ChessEquipment15.init_hero(hero)
  hero.update = override(hero.update, ChessEquipment15.hero_update)
  hero.reset = override(hero.reset, ChessEquipment15.hero_reset)
  return hero
end

return ChessEquipment15.init_hero
