local function onBuffRemove(basefunc, buff)
  basefunc(buff)
  
  if buff.owner then
  end
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  buff.owner.MagicStoneEffect_buff_6 = true
end

local function buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.time_count then
    buff.time_count = buff.time_count + dt
    if buff.time_count >= 15 and buff.owner.MagicStoneEffect_buff_6 then
      buff.owner.MagicStoneEffect_buff_6 = false
      local shield_vaule = math.min(buff.info["Script Arg 1"], 100000)
      local bid = 366
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local shield_buff = ed.BuffCreate(binfo, buff.owner, buff.owner)
      shield_buff.shield = shield_vaule
      buff.owner:addBuff(shield_buff, buff.owner)
    end
  else
    buff.time_count = 0
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
