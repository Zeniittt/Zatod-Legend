local function onBuffRemove(basefunc, buff)
  basefunc(buff)
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.owner.MagicStoneEffect_buff_18 = true
    buff.owner.MagicStoneEffect_buff_18_value = 0
  end
end

local function MagicStoneEffect_buff_18_onRemoved(basefunc, buff)
  local owner = buff.owner
  for _, tbuff in ipairs(owner.buff_list) do
    local willBeRemove = tbuff:isCrlEftConflictWithUncontrollable() or ed.isElementInTable("stunbyself", buff.info["Control Effects"]) and tbuff.caster ~= owner
    if willBeRemove then
      tbuff.timer = -1
      local bid = 4615
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local buff_s = ed.BuffCreate(binfo, owner, owner)
      buff_s.timer = 0.25
      owner:addBuff(buff_s, owner)
    end
  end
  for unit in ed.engine:foreachAliveUnit(-owner.camp) do
    local distanceSQ = ed.edpDistanceSQ(unit.position, owner.position)
    if distanceSQ <= 22500 and owner.MagicStoneEffect_buff_18_value then
      unit:takeDamage(owner.MagicStoneEffect_buff_18_value, "Holy", "hp", owner)
    end
  end
  basefunc(buff)
end

local function buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if buff.time_count then
    buff.time_count = buff.time_count + dt
    if buff.time_count >= 3 and owner.MagicStoneEffect_buff_18 and owner.MagicStoneEffect_buff_18_value then
      owner.MagicStoneEffect_buff_18 = false
      local shield_value = math.min(buff.info["Script Arg 1"], 50000)
      owner.MagicStoneEffect_buff_18_value = shield_value
      local bid = 1589
      local binfo = ed.lookupDataTable("Buff", nil, bid)
      local shield_buff = ed.BuffCreate(binfo, owner, owner)
      shield_buff.timer = 90
      shield_buff.shield = shield_value
      shield_buff.onRemoved = override(shield_buff.onRemoved, MagicStoneEffect_buff_18_onRemoved)
      owner:addBuff(shield_buff, owner)
    end
  else
    buff.time_count = 0
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, buffUpdate)
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  buff.onAddedServer = override(buff.onAddedServer, onBuffAdderServer)
  return buff
end

return initBuff
