local function onBuffRemove(basefunc, buff)
  basefunc(buff)
end

local function onBuffAdderServer(basefunc, buff)
  basefunc(buff)
  if buff.owner then
  end
end

local function onBuffDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  local lost = basefunc(buff, damage, damage_type, source, skill, transferred, field)
  local owner = buff.owner
  local resist_value = buff.info["Script Arg 1"]
  if owner:isAlive() and lost and 0 < lost and damage_type == "AD" then
    local plus = (10 - math.ceil(owner.hp / owner.attribs.HP * 10)) / 10
    resist_value = math.min(resist_value * (1 + plus), lost * 0.25)
    lost = lost - resist_value
  end
  return lost
end

local function initBuff(buff)
  buff.onRemoved = override(buff.onRemoved, onBuffRemove)
  buff.onAddedServer = override(buff.onAddedServer, onBuffAdderServer)
  buff.onDamaged = override(buff.onDamaged, onBuffDamaged)
  return buff
end

return initBuff
