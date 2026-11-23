local function onBuffRemove(baseFunc, buff)
  baseFunc(buff)
  
  if buff.owner then
    buff.caster.detaunter = nil
  end
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.caster.detaunter = buff.owner
  end
end

local function buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if not buff.caster:isAlive() then
    buff.owner:removeBuff(buff)
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, buffUpdate)
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  buff.onAddedServer = override(buff.onAddedServer, onBuffAdderServer)
  return buff
end

return initBuff
