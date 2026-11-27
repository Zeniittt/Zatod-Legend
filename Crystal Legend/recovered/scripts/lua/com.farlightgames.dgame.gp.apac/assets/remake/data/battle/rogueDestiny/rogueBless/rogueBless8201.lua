local class = newclass("g")
ed.rogueBless8201 = class

function class.initBless(bless)
  for unit in ed.engine:foreachAliveUnit(ed.emCampEnemy) do
    if not unit.config.is_summoned then
      local buffInfo1 = ed.getDataTable("Buff")[60018201]
      local buff1 = ed.BuffCreate(buffInfo1, unit, unit)
      unit:addBuff(buff1, unit)
      local buffInfo2 = ed.getDataTable("Buff")[60028201]
      local buff2 = ed.BuffCreate(buffInfo2, unit, unit)
      unit:addBuff(buff2, unit)
    end
  end
  return bless
end

return class.initBless
