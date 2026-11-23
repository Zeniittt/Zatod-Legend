local function onBuffRemove(basefunc, buff)
  basefunc(buff)
  
  if buff.owner then
  end
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  buff.owner.MagicStoneEffect_buff_15 = true
  local POAP = math.min(buff.info["Script Arg 1"], 30) * 0.01 * buff.owner.attribs.AP
  buff.Total_POAP = POAP
  buff:setAttribute("AP", POAP)
end

local function buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  if buff.time_count then
    buff.time_count = buff.time_count + dt
    if buff.time_count <= 20 and buff.owner.MagicStoneEffect_buff_15 and math.ceil(buff.time_count) == buff.time_count then
      local POAP = buff.Total_POAP
      if POAP then
        buff:setAttribute("AP", POAP - POAP / 20 * math.ceil(buff.time_count))
        buff.owner:resetBuffApply(buff)
      end
    elseif buff.time_count > 20 then
      buff.owner.MagicStoneEffect_buff_15 = false
      buff.timer = -1
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
