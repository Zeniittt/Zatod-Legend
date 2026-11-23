local class = newclass("g")
ed.rogueBless2204 = class

function class.initBless(bless)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    unit.rogueBless2204count = 0
  end
  return bless
end

return class.initBless
