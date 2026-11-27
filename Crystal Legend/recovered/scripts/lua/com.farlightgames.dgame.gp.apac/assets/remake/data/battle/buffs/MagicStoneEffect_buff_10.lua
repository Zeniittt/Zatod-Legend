local function onBuffRemove(basefunc, buff)
  basefunc(buff)
  
  if buff.owner then
  end
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  buff.owner.MagicStoneEffect_buff_10 = true
  buff.DamageDown = math.min(buff.info["Script Arg 1"], 60)
  if not buff.Total_DamageDown then
    buff.Total_DamageDown = buff.DamageDown
  end
end

local function buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.time_count then
    buff.time_count = buff.time_count + dt
    if buff.time_count <= 20 and buff.owner.MagicStoneEffect_buff_10 and math.ceil(buff.time_count) == buff.time_count then
      local DamageDown = buff.Total_DamageDown
      if DamageDown then
        buff.DamageDown = DamageDown - DamageDown / 20 * math.ceil(buff.time_count)
      end
    elseif buff.time_count > 20 then
      buff.owner.MagicStoneEffect_buff_10 = false
      buff.DamageDown = 0
      buff.timer = -1
    end
  else
    buff.time_count = 0
  end
end

local function onBuffDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  if lost then
    local DamageDown = buff.DamageDown
    if DamageDown and 0 < DamageDown then
      lost = lost * (100 - DamageDown) / 100
    end
  end
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
