local class = newclass("g")
ed.rogueBless7101 = class

function class.initBless(bless)
  local rogueRevelation = bless.rogueRevelation
  rogueRevelation:addEnergy(bless.info["Script Arg1"])
  return bless
end

return class.initBless
