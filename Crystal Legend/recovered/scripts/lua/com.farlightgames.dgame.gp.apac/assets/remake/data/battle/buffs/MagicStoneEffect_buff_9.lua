local function onBuffRemove(basefunc, buff)
  basefunc(buff)
  
  if buff.owner then
  end
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.owner.MagicStoneEffect_buff_9 = true
    buff.owner.MagicStoneEffect_buff_9s = false
  end
end

local function buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner:isAlive() and owner.MagicStoneEffect_buff_9s then
    owner.MagicStoneEffect_buff_9s = false
    local shield_vaule = math.min(buff.info["Script Arg 1"], 100000)
    local bid = 366
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local shield_buff = ed.BuffCreate(binfo, buff.owner, buff.owner)
    shield_buff.shield = shield_vaule
    buff.owner:addBuff(shield_buff, buff.owner)
  end
end

local function onBuffDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  local owner = buff.owner
  if owner:isAlive() and lost and lost > owner.attribs.HP * 0.3 and damage_type ~= "Heal" and owner.MagicStoneEffect_buff_9 then
    owner.MagicStoneEffect_buff_9 = false
    owner.MagicStoneEffect_buff_9s = true
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
