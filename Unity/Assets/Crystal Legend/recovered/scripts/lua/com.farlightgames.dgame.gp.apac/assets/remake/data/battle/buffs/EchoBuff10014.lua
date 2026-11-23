local function Echobuff10014_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local target = buff.owner
  local caster = buff.caster
  buff.dt = buff.dt and buff.dt + dt or dt
  if target and caster and buff.dt == 0.125 then
    caster.Echobuff10014_casted = true
    local AP = target.attribs.AP
    buff:setAttribute("AP", 0.6 * AP)
    target:resetBuffApply(buff)
  end
end

local function Echobuff10014_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  if caster then
    caster.Echobuff10014_casted = false
  end
end

local function initBuff(buff)
  local caster = buff.caster
  if caster then
    caster.Echobuff10014_casted = false
  end
  buff.update = override(buff.update, Echobuff10014_update)
  buff.onRemoved = override(buff.onRemoved, Echobuff10014_onRemoved)
  return buff
end

return initBuff
