local function onBuffRemove(baseFunc, buff)
  baseFunc(buff)
  
  if buff.owner then
    buff.owner:summonSelf(ed.emCampPlayer)
  end
end

local function initBuff(buff)
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  return buff
end

return initBuff
