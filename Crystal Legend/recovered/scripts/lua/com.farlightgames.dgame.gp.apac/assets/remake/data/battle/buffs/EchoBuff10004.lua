local function Echobuff10004_onDamaged(basefunc, buff, damage, damage_type, source, skill, transferred, field)
  if source and damage then
    local INT = source.attribs.INT
    
    if INT then
      damage = damage * (1 + INT / 1500)
    end
  end
  return basefunc(buff, damage, damage_type, source, skill, transferred, field)
end

local function initBuff(buff)
  buff.onDamaged = override(buff.onDamaged, Echobuff10004_onDamaged)
  return buff
end

return initBuff
