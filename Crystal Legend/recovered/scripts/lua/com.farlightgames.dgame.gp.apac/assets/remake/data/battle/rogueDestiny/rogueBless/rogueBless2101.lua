local class = newclass("g")
ed.rogueBless2101 = class

function class.initBless(bless)
  local rogueRevelation = bless.rogueRevelation
  rogueRevelation:addEnergy(bless.info["Script Arg1"])
  rogueRevelation.energyReturn = rogueRevelation.energyReturn * (1 + bless.info["Script Arg2"] / 100)
  return bless
end

return class.initBless
