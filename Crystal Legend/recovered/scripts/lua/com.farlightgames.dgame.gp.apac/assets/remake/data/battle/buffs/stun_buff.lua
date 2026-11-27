local function onBuffRemove(baseFunc, buff)
  baseFunc(buff)
  
  if buff.owner then
    buff.owner:setIdleAction("Idle")
  end
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.owner:setIdleAction("Stun")
  end
end

local function initBuff(buff)
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  buff.onAddedServer = override(buff.onAddedServer, onBuffAdderServer)
  return buff
end

return initBuff
