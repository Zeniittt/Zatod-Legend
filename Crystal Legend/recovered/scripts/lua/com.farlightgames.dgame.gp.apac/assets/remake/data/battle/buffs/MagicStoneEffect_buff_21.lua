local function onBuffDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  
  local owner = buff.owner
  if lost and 0 < lost and lost > owner.hp and owner.MagicStoneEffect_buff_21 then
    owner.MagicStoneEffect_buff_21 = false
    local buffduration = math.min(buff.info["Script Arg 1"], 5)
    local dispel = 1
    for unit in ed.engine:foreachAliveUnit(owner.camp) do
      if unit.info["Unit Type"] == "Hero" then
        local bid = 1672
        local binfo = ed.lookupDataTable("Buff", nil, bid)
        local buff_s = ed.BuffCreate(binfo, unit, owner)
        buff_s.timer = buffduration
        unit:addBuff(buff_s, owner)
        if dispel then
          for _, tbuff in ipairs(unit.buff_list) do
            local willBeRemove = tbuff:isCrlEftConflictWithUncontrollable()
            if willBeRemove then
              tbuff.timer = -1
            end
          end
        end
      end
    end
  end
  return lost
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.owner.MagicStoneEffect_buff_21 = true
  end
end

local function initBuff(buff)
  buff.onAddedServer = override(buff.onAddedServer, onBuffAdderServer)
  buff.onDamaged = override(buff.onDamaged, onBuffDamaged)
  return buff
end

return initBuff
