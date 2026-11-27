local function onBuffRemove(basefunc, buff)
  basefunc(buff)
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
    buff.owner.MagicStoneEffect_buff_16 = true
  end
end

local function buffUpdate(basefunc, buff, dt)
  basefunc(buff, dt)
  local owner = buff.owner
  if owner.hp <= owner.attribs.HP * 0.4 and owner.MagicStoneEffect_buff_16 and not owner.current_skill and not owner.manually_casting and not owner.buff_effects.uncontrollable then
    owner.MagicStoneEffect_buff_16 = false
    local hpr_value = math.min(buff.info["Script Arg 1"], 100000)
    local bid = 4447
    local binfo = ed.lookupDataTable("Buff", nil, bid)
    local buff_s = ed.BuffCreate(binfo, owner, owner)
    buff_s.timer = 4
    buff_s:setAttribute("HPR", hpr_value)
    buff_s:setAttribute("PIMU", 50)
    buff_s:setAttribute("MIMU", 50)
    owner:addBuff(buff_s, owner)
  end
end

local function initBuff(buff)
  buff.update = override(buff.update, buffUpdate)
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  buff.onAddedServer = override(buff.onAddedServer, onBuffAdderServer)
  return buff
end

return initBuff
