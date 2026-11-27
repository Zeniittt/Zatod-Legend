module("ed.battlehero", package.seeall)
local ed = ed
ChessEquipment14 = {}
ChessEquipment14.startBuffID = 1349

function ChessEquipment14.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.start_buffadded then
    local bid = ChessEquipment14.startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.start_buffadded = true
  end
  if not pet.ChessEquipment14_firsttick then
    pet.ChessEquipment14_firsttick = ed.engine.ticks
  end
  local master = pet.owner
  if ed.engine.ticks - pet.ChessEquipment14_firsttick > 8 and not pet.Equipment14_skillpasv_casted then
    local bid = 7037
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    master:addBuff(binfo, master)
    for unit in ed.engine:foreachAliveUnit(-master.camp) do
      if not unit.config.is_summoned and unit:isAlive() then
        local skillpasv = pet.skills.equipment14
        if skillpasv and unit then
          local buff = unit:addBuff(skillpasv:createBuff(unit), master)
          if buff then
            buff.onDamaged = override(buff.onDamaged, ChessEquipment14.equipment14_buff_onDamaged)
          end
        end
      end
    end
    pet.Equipment14_skillpasv_casted = true
  end
end

function ChessEquipment14.equipment14_buff_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local caster = buff.caster
  local owner = buff.owner
  if caster and owner and source and source == caster.owner and damage and 0 < damage then
    owner:takeDamage(100, "Holy", "mp", caster)
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field)
end

function ChessEquipment14.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.start_buffadded = nil
  pet.Equipment14_skillpasv_casted = nil
end

function ChessEquipment14.init_hero(hero)
  hero.update = override(hero.update, ChessEquipment14.hero_update)
  hero.reset = override(hero.reset, ChessEquipment14.hero_reset)
  return hero
end

return ChessEquipment14.init_hero
