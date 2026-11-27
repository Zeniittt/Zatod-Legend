local class = newclass("g")
ed.rogueBless1315 = class

function class.initBless(bless)
  for unit in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    unit:takeHeal(bless.isReinforced and bless.info["Script Arg5"] or bless.info["Script Arg1"], "mp")
  end
  return bless
end

return class.initBless
