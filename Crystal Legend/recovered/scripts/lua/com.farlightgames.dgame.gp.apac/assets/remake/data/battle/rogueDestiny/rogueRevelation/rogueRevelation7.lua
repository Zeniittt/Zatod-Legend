local class = newclass("g")
ed.rogueRevelation7 = class

function class.rogueRevelationisCanCast(basefunc, rogueRevelation)
  local cancast = basefunc(rogueRevelation)
  for player in ed.engine:foreachAliveUnit(ed.emCampPlayer) do
    if player.revelation7buff then
      cancast = false
      break
    end
  end
  return cancast
end

function class.rogueRevelationcreateBuff(basefunc, rogueRevelation, target)
  local buff = basefunc(rogueRevelation, target)
  buff.timer = rogueRevelation.info["Script Arg1"]
  target.revelation7buff = true
  target.revelation7buffshield = rogueRevelation.info["Script Arg2"]
  buff:setAttribute("AP", target.attribs.AP)
  buff:setAttribute("AD", target.attribs.AD)
  buff.onRemoved = override(buff.onRemoved, class.rogueRevelation7BuffRemove)
  return buff
end

function class.rogueRevelation7BuffRemove(basefunc, buff)
  local owner = buff.owner
  basefunc(buff)
  owner.revelation7buff = false
  owner.revelation7buffshield = 0
end

function class.init(rogueRevelation)
  rogueRevelation.isCanCast = override(rogueRevelation.isCanCast, class.rogueRevelationisCanCast)
  rogueRevelation.createBuff = override(rogueRevelation.createBuff, class.rogueRevelationcreateBuff)
  return rogueRevelation
end

return class.init
