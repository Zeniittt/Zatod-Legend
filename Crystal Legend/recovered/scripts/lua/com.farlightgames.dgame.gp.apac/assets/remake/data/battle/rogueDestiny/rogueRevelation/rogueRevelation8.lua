local class = newclass("g")
ed.rogueRevelation8 = class

function class.revelationcreateBuff(basefunc, rogueRevelation, target)
  local buff = basefunc(rogueRevelation, target)
  buff.timer = rogueRevelation.info["Script Arg1"]
  if target.camp == 1 then
    buff:setAttribute("CSD", rogueRevelation.info["Script Arg2"])
    buff:setAttribute("MCSD", rogueRevelation.info["Script Arg2"])
  end
  return buff
end

function class.init(rogueRevelation)
  rogueRevelation.createBuff = override(rogueRevelation.createBuff, class.revelationcreateBuff)
  return rogueRevelation
end

return class.init
