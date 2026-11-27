local function Echobuff10001_update(basefunc, buff, dt)
  basefunc(buff, dt)
  
  local target = buff.owner
  local caster = buff.caster
  if not buff.haseffect then
    buff.haseffect = true
    if target and caster then
      local hp = target.attribs.HP * 0.1
      target:takeDamage(hp, "Holy", "hp", caster)
      buff.timer = -1
    end
  end
end

local function Echobuff10001_onRemoved(basefunc, buff)
  basefunc(buff)
  local caster = buff.caster
  if caster then
    caster.EchoBuff10001hasCast = 0
  end
end

local function initBuff(buff)
  local caster = buff.caster
  if caster then
    caster.EchoBuff10001hasCast = 0
  end
  buff.update = override(buff.update, Echobuff10001_update)
  buff.onRemoved = override(buff.onRemoved, Echobuff10001_onRemoved)
  return buff
end

return initBuff
