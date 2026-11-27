local class = newclass("g")
ed.rogueBless3310 = class

function class.initBless(bless)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    unit.rogueBless3310count = 0
  end
  return bless
end

return class.initBless
