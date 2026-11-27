local class = newclass("g")
ed.rogueRevelation4 = class

function class.revelationpower(basefunc, self, target, damage_type)
  local info = self.info
  local ratio = info["Script Arg1"] / 100
  local power = target.attribs.HP * ratio
  return power, 1
end

function class.init(rogueRevelation)
  rogueRevelation.power = override(rogueRevelation.power, class.revelationpower)
  return rogueRevelation
end

return class.init
