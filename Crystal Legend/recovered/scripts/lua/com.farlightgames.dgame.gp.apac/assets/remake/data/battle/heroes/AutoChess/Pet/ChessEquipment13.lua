module("ed.battlehero", package.seeall)
local ed = ed
ChessEquipment13 = {}
ChessEquipment13.startBuffID = 1349

function ChessEquipment13.hero_update(basefunc, pet, dt)
  basefunc(pet, dt)
  if not pet.start_buffadded then
    local bid = ChessEquipment13.startBuffID
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    pet:addBuff(binfo, pet)
    pet.start_buffadded = true
  end
  if not pet.ChessEquipment13_firsttick then
    pet.ChessEquipment13_firsttick = ed.engine.ticks
  end
  local master = pet.owner
  if ed.engine.ticks - pet.ChessEquipment13_firsttick > 8 and not pet.Equipment13_skillpasv_casted then
    for unit in ed.engine:foreachAliveUnit(-master.camp) do
      unit.rand_select = ed.rand()
    end
    local select_unit
    local max_select = math.huge
    for unit in ed.engine:foreachAliveUnit(-master.camp) do
      if not unit.buff_effects.invulnerable and not unit.config.is_summoned and unit:isAlive() then
        local d = unit.rand_select
        if max_select > d then
          select_unit = unit
          max_select = d
        end
      end
    end
    local skillpasv = pet.skills.equipment13
    if skillpasv and select_unit then
      select_unit:addBuff(skillpasv:createBuff(select_unit), master)
      pet.Equipment13_skillpasv_casted = true
    end
  end
end

function ChessEquipment13.hero_reset(basefunc, pet)
  basefunc(pet)
  pet.start_buffadded = nil
  pet.Equipment13_skillpasv_casted = nil
end

function ChessEquipment13.init_hero(hero)
  hero.update = override(hero.update, ChessEquipment13.hero_update)
  hero.reset = override(hero.reset, ChessEquipment13.hero_reset)
  return hero
end

return ChessEquipment13.init_hero
