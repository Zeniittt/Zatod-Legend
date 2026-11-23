local function onBuffRemove(basefunc, buff)
  basefunc(buff)
  
  if buff.owner then
  end
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.owner.MagicStoneEffect_buff_3 = true
  end
end

local function buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner and owner.manually_casting and owner.MagicStoneEffect_buff_3 then
    owner.MagicStoneEffect_buff_3 = false
    local addmp = math.min(buff.info["Script Arg 1"], 300)
    owner:setMP(owner.mp + addmp)
  end
end

local function onBuffDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  return lost
end

local function initBuff(buff)
  buff.update = override(buff.update, buffUpdate)
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  buff.onAddedServer = override(buff.onAddedServer, onBuffAdderServer)
  buff.onDamaged = override(buff.onDamaged, onBuffDamaged)
  return buff
end

return initBuff
