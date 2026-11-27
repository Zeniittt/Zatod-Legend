local function onBuffRemove(baseFunc, buff)
  baseFunc(buff)
  
  if buff.owner then
    buff.owner:removeFury(buff.fury_id)
  end
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.fury_id = buff.owner:useFury(buff.info["friend discount"])
  end
end

local function initBuff(buff)
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  buff.onAddedServer = override(buff.onAddedServer, onBuffAdderServer)
  return buff
end

return initBuff
