local class = newclass("g")
ed.rogueBless4101 = class

function class.initBless(bless)
  local rogueRevelation = bless.rogueRevelation
  rogueRevelation.energyReturn = rogueRevelation.energyReturn * (1 + bless.info["Script Arg1"] / 100)
  return bless
end

return class.initBless
