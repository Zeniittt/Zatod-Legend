local function Echobuff10015_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local target = buff.owner
  local caster = buff.caster
  buff.dt = buff.dt and buff.dt + dt or dt
  if target and caster and buff.dt == 0.125 then
    caster.Echobuff10015_casted = true
    local AD = target.attribs.AD
    buff:setAttribute("AD", 0.3 * AD)
    target:resetBuffApply(buff)
  end
end

local function Echobuff10015_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  if caster then
    caster.Echobuff10015_casted = false
  end
end

local function initBuff(buff)
  local caster = buff.caster
  if caster then
    caster.Echobuff10015_casted = false
  end
  buff.update = override(buff.update, Echobuff10015_update)
  buff.onRemoved = override(buff.onRemoved, Echobuff10015_onRemoved)
  return buff
end

return initBuff
