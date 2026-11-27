local function Echobuff10003_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local target = buff.owner
  local caster = buff.caster
  if target and caster and not target.Echobuff10003_casted then
    target.Echobuff10003_casted = true
    local hpr = target.attribs.HP * 0.08
    buff:setAttribute("HPR", hpr)
    target:resetBuffApply(buff)
  end
end

local function Echobuff10003_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  local target = buff.owner
  if target then
    target.Echobuff10003_casted = false
  end
end

local function initBuff(buff)
  local target = buff.owner
  if target then
    target.Echobuff10003_casted = false
  end
  buff.update = override(buff.update, Echobuff10003_update)
  buff.onRemoved = override(buff.onRemoved, Echobuff10003_onRemoved)
  return buff
end

return initBuff
