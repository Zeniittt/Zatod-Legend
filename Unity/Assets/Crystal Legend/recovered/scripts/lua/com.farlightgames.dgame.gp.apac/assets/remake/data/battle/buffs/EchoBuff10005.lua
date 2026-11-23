local function Echobuff10005_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local target = buff.owner
  local caster = buff.caster
  if target and caster and not caster.Echobuff10005_casted then
    caster.Echobuff10005_casted = true
    local AD = target.attribs.AD * 0.5
    local ARM = target.attribs.ARM * 0.5
    local MR = target.attribs.MR * 0.5
    buff:setAttribute("AD", -AD)
    buff:setAttribute("ARM", -ARM)
    buff:setAttribute("MR", -MR)
    target:resetBuffApply(buff)
  end
end

local function Echobuff10005_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  if caster then
    caster.Echobuff10005_casted = false
  end
end

local function initBuff(buff)
  local caster = buff.caster
  if caster then
    caster.Echobuff10005_casted = false
  end
  buff.update = override(buff.update, Echobuff10005_update)
  buff.onRemoved = override(buff.onRemoved, Echobuff10005_onRemoved)
  return buff
end

return initBuff
